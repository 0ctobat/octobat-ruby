module Octobat
  class OctobatError < StandardError
    attr_accessor :message
    attr_reader :error
    attr_reader :http_status
    attr_reader :http_body
    attr_reader :json_body

    def initialize(error=nil, http_status=nil, http_body=nil, json_body=nil)
      @error = error
      @http_status = http_status
      @http_body = http_body
      @json_body = json_body
    end
    
    def message
      @message ||= generate_message_from_error
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status #{@http_status}) "
      "#{status_string}#{@message}"
    end
    
    def generate_message_from_error
      return "" if @error.nil?
      a = []
      
      puts @error.inspect
      
      @error.each_key do |k|
        msg = k.eql?(:global) ? "" : "#{k.to_s}: "
        msg << "#{serialize_errors_from(@error[k])}"
        a << msg
      end
      
      a.join(". ")
    end
    
    def serialize_errors_from(err)
      a = []
      err.each do |e|
        a << "#{e[:details]}"
      end
      a.join(', ')
    end
  end
end