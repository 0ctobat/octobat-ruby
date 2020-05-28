module Octobat
  class CreditNote < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update
    
    
    def self.pdf_export(params = {}, opts={})
      api_key, headers = Util.parse_opts(opts)
      api_key ||= @api_key
      opts[:api_key] = api_key

      instance = self.new(nil, opts)

      response, api_key = Octobat.request(:post, url + '/pdf_export', api_key, params, headers)
      return true
    end
    

    def send_by_email(params = {}, opts = {})
      response, api_key = Octobat.request(:post, send_url, @api_key, params, opts)
      refresh_from(response, api_key)
    end

    def confirm(params = {}, opts = {})
      response, api_key = Octobat.request(:patch, confirm_url, @api_key, params, opts)
      refresh_from(response, api_key)
    end
    
    
    def cancel(params = {}, opts = {})
      response, api_key = Octobat.request(:patch, cancel_url, @api_key, params, opts)
      refresh_from(response, api_key)
    end
    
    

    def items(params = {}, opts = {})
      Item.list(params.merge({ credit_note: id }), {api_key: @api_key}.merge(opts))
    end

    def transactions(params = {}, opts = {})
      Transaction.list(params.merge(credit_note: id), {api_key: @api_key}.merge(opts))
    end

    private
      def cancel_url
        url + '/cancel'
      end

      def send_url
        url + '/send'
      end

      def confirm_url
        url + '/confirm'
      end
  end
end
