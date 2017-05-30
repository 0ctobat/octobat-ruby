module Octobat
  class CreditNote < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

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
