module Octobat
  class Invoice < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def payments(payment_data)
      response, api_key = Octobat.request(:post, pay_url, @api_key, payment_data)
      refresh_from(response, api_key)
    end

    def send_by_email(email_data = {})
      response, api_key = Octobat.request(:post, send_url, @api_key, email_data)
      refresh_from(response, api_key)
    end

    def confirm
      response, api_key = Octobat.request(:patch, confirm_url, @api_key)
      refresh_from(response, api_key)
    end

    def cancel
      response, api_key = Octobat.request(:patch, cancel_url, @api_key)
      refresh_from(response, api_key)
    end

    def cancel_and_replace
      response, api_key = Octobat.request(:patch, cancel_and_replace_url, @api_key)
      refresh_from(response, api_key)
    end

    def delete
      response, api_key = Octobat.request(:delete, url, @api_key)
      refresh_from(response, api_key)
    end

    def items(params = {})
      Item.list(params.merge({ :invoice => id }), @api_key)
    end

    private

      def pay_url
        url + '/payments'
      end

      def send_url
        url + '/send'
      end

      def confirm_url
        url + '/confirm'
      end

      def cancel_url
        url + '/cancel'
      end

      def cancel_and_replace_url
        url + '/cancel_and_replace'
      end

  end


end
