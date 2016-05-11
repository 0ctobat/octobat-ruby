module Octobat
  class CreditNote < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def refunds(refund_data)
      response, api_key = Octobat.request(:post, refund_url, @api_key, refund_data)
      refresh_from(response, api_key)
    end

    def send(enforce_errors = false)
      response, api_key = Octobat.request(:post, send_url, @api_key, {enforce_errors: enforce_errors})
      refresh_from(response, api_key)
    end

    def items(params = {})
      Item.list(params.merge({ :invoice => id }), @api_key)
    end

    private

      def refund_url
        url + '/refunds'
      end

      def send_url
        url + '/send'
      end
  end
end
