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

      response, api_key = Octobat.request(:post, url + '/pdf_export', api_key, params)
      return true
    end
    

    def send_by_email(email_data = {})
      response, api_key = Octobat.request(:post, send_url, @api_key, email_data)
      refresh_from(response, api_key)
    end

    def confirm(confirmation_data = {})
      response, api_key = Octobat.request(:patch, confirm_url, @api_key, confirmation_data)
      refresh_from(response, api_key)
    end

    def items(params = {})
      Item.list(params.merge({credit_note: id }), @api_key)
    end

    def transactions(params = {})
      Transaction.list(params.merge(credit_note: id), @api_key)
    end

    private

      def send_url
        url + '/send'
      end

      def confirm_url
        url + '/confirm'
      end
  end
end
