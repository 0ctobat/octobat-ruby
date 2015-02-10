# Octobat Ruby bindings
# API spec at https://www.octobat.com/docs/api
require 'cgi'
require 'set'
require 'openssl'
require 'rest_client'
require 'base64'
require 'json'

# Version
require 'octobat/version'

# API operations
require 'octobat/api_operations/create'
require 'octobat/api_operations/update'
require 'octobat/api_operations/delete'
require 'octobat/api_operations/list'

# Resources
require 'octobat/util'
require 'octobat/octobat_object'
require 'octobat/api_resource'
require 'octobat/singleton_api_resource'
require 'octobat/list_object'

require 'octobat/numbering_sequence'
require 'octobat/payment_mode'
require 'octobat/payment'
require 'octobat/credit_note_numbering_sequence'
require 'octobat/customer'
require 'octobat/invoice'
require 'octobat/invoice_item'

# Errors
require 'octobat/errors/octobat_error'
require 'octobat/errors/api_error'
require 'octobat/errors/api_connection_error'
require 'octobat/errors/invalid_request_error'
require 'octobat/errors/authentication_error'

module Octobat
  #DEFAULT_CA_BUNDLE_PATH = File.dirname(__FILE__) + '/data/ca-certificates.crt'
  @api_base = 'https://api.octobat.com'

  #@ssl_bundle_path  = DEFAULT_CA_BUNDLE_PATH
  #@verify_ssl_certs = true
  #@CERTIFICATE_VERIFIED = false


  class << self
    attr_accessor :api_key, :api_base, :verify_ssl_certs, :api_version
  end

  def self.api_url(url='', api_base_url=nil)
    (api_base_url || @api_base) + url
  end

  def self.request(method, url, api_key, params={}, headers={}, api_base_url=nil)
    api_base_url = api_base_url || @api_base

    unless api_key ||= @api_key
      raise AuthenticationError.new('No API key provided. ' \
        'Set your API key using "Octobat.api_key = <API-KEY>". ')
    end

    if api_key =~ /\s/
      raise AuthenticationError.new('Your API key is invalid, as it contains ' \
        'whitespace. (HINT: You can double-check your API key from the ' \
        'Octobat web interface).')
    end

    request_opts = { :verify_ssl => true }

    #if ssl_preflight_passed?
    #  request_opts.update(:verify_ssl => OpenSSL::SSL::VERIFY_PEER,
    #                      :ssl_ca_file => @ssl_bundle_path)
    #end

    #if @verify_ssl_certs and !@CERTIFICATE_VERIFIED
    #  @CERTIFICATE_VERIFIED = CertificateBlacklist.check_ssl_cert(api_base_url, @ssl_bundle_path)
    #end

    params = Util.objects_to_ids(params)
    params = Util.expand_nested_objects(params)
    url = api_url(url, api_base_url)

    case method.to_s.downcase.to_sym
    when :get, :head, :delete
      # Make params into GET parameters
      url += "#{URI.parse(url).query ? '&' : '?'}#{uri_encode(params)}" if params && params.any?
      payload = nil
    else
      if headers[:content_type] && headers[:content_type] == "multipart/form-data"
        payload = params
      else
        payload = uri_encode(params)
      end
    end

    request_opts.update(:headers => request_headers(api_key).update(headers),
                        :method => method, :open_timeout => 30,
                        :payload => payload, :url => url, :timeout => 80)

    begin
      response = execute_request(request_opts)
    rescue SocketError => e
      handle_restclient_error(e, api_base_url)
    rescue NoMethodError => e
      # Work around RestClient bug
      if e.message =~ /\WRequestFailed\W/
        e = APIConnectionError.new('Unexpected HTTP response code')
        handle_restclient_error(e, api_base_url)
      else
        raise
      end
    rescue RestClient::ExceptionWithResponse => e
      if rcode = e.http_code and rbody = e.http_body
        handle_api_error(rcode, rbody)
      else
        handle_restclient_error(e, api_base_url)
      end
    rescue RestClient::Exception, Errno::ECONNREFUSED => e
      handle_restclient_error(e, api_base_url)
    end

    [parse(response), api_key]
  end

  private

=begin
  def self.ssl_preflight_passed?
    if !verify_ssl_certs && !@no_verify
      $stderr.puts "WARNING: Running without SSL cert verification. " \
        "Execute 'Octobat.verify_ssl_certs = true' to enable verification."

      @no_verify = true

    elsif !Util.file_readable(@ssl_bundle_path) && !@no_bundle
      $stderr.puts "WARNING: Running without SSL cert verification " \
        "because #{@ssl_bundle_path} isn't readable"

      @no_bundle = true
    end

    !(@no_verify || @no_bundle)
  end
=end

  def self.user_agent
    @uname ||= get_uname
    lang_version = "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"

    {
      :bindings_version => Octobat::VERSION,
      :lang => 'ruby',
      :lang_version => lang_version,
      :platform => RUBY_PLATFORM,
      :publisher => 'octobat',
      :uname => @uname
    }

  end

  def self.get_uname
    `uname -a 2>/dev/null`.strip if RUBY_PLATFORM =~ /linux|darwin/i
  rescue Errno::ENOMEM => ex # couldn't create subprocess
    "uname lookup failed"
  end

  def self.uri_encode(params)
    Util.flatten_params(params).
      map { |k,v| "#{k}=#{Util.url_encode(v)}" }.join('&')
  end

  def self.request_headers(api_key)
    headers = {
      :user_agent => "Octobat/v1 RubyBindings/#{Octobat::VERSION}",
      :authorization => 'Basic ' + Base64.encode64( "#{api_key}:" ).chomp,
      :content_type => 'application/x-www-form-urlencoded'
    }

    headers[:octobat_version] = api_version if api_version

    begin
      headers.update(:x_octobat_client_user_agent => JSON.generate(user_agent))
    rescue => e
      headers.update(:x_octobat_client_raw_user_agent => user_agent.inspect,
                     :error => "#{e} (#{e.class})")
    end
  end

  def self.execute_request(opts)
    RestClient::Request.execute(opts)
  end

  def self.parse(response)
    begin
      # Would use :symbolize_names => true, but apparently there is
      # some library out there that makes symbolize_names not work.
      response = JSON.parse(response.body)
    rescue JSON::ParserError
      raise general_api_error(response.code, response.body)
    end

    Util.symbolize_names(response)
  end

  def self.general_api_error(rcode, rbody)
    APIError.new("Invalid response object from API: #{rbody.inspect} " +
                 "(HTTP response code was #{rcode})", rcode, rbody)
  end

  def self.handle_api_error(rcode, rbody)
    begin
      error_obj = JSON.parse(rbody)
      error_obj = Util.symbolize_names(error_obj)
      error = error_obj[:error] or raise OctobatError.new # escape from parsing

    rescue JSON::ParserError, OctobatError
      raise general_api_error(rcode, rbody)
    end

    case rcode
    when 400, 404
      raise invalid_request_error error, rcode, rbody, error_obj
    when 401
      raise authentication_error error, rcode, rbody, error_obj
    else
      raise api_error error, rcode, rbody, error_obj
    end

  end

  def self.invalid_request_error(error, rcode, rbody, error_obj)
    InvalidRequestError.new(error[:message], error[:param], rcode,
                            rbody, error_obj)
  end

  def self.authentication_error(error, rcode, rbody, error_obj)
    AuthenticationError.new(error[:message], rcode, rbody, error_obj)
  end

  def self.card_error(error, rcode, rbody, error_obj)
    CardError.new(error[:message], error[:param], error[:code],
                  rcode, rbody, error_obj)
  end

  def self.api_error(error, rcode, rbody, error_obj)
    APIError.new(error[:message], rcode, rbody, error_obj)
  end

  def self.handle_restclient_error(e, api_base_url=nil)
    api_base_url = @api_base unless api_base_url
    connection_message = "Please check your internet connection and try again. " \
        "If this problem persists, you should check Octobat's service status at " \
        "https://twitter.com/octobat, or let us know at contact@octobat.com."

    case e
    when RestClient::RequestTimeout
      message = "Could not connect to Octobat (#{api_base_url}). #{connection_message}"

    when RestClient::ServerBrokeConnection
      message = "The connection to the server (#{api_base_url}) broke before the " \
        "request completed. #{connection_message}"

    when RestClient::SSLCertificateNotVerified
      message = "Could not verify Octobat's SSL certificate. " \
        "Please make sure that your network is not intercepting certificates. " \
        "(Try going to https://api.octobat.com/ in your browser.) " \
        "If this problem persists, let us know at contact@octobat.com."

    when SocketError
      message = "Unexpected error communicating when trying to connect to Octobat. " \
        "You may be seeing this message because your DNS is not working. " \
        "To check, try running 'host octobat.com' from the command line."

    else
      message = "Unexpected error communicating with Octobat. " \
        "If this problem persists, let us know at contact@octobat.com."

    end

    raise APIConnectionError.new(message + "\n\n(Network error: #{e.message})")
  end
end
