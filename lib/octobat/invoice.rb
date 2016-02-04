module Octobat
  class Invoice < APIResource
    include Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def pay(payment_data)
      response, api_key = Octobat.request(:patch, pay_url, @api_key, {payment: payment_data})
      refresh_from(response, api_key)
    end
    
    def send(enforce_errors = false)
      response, api_key = Octobat.request(:post, send_url, @api_key, {enforce_errors: enforce_errors})
      refresh_from(response, api_key)
    end
    
    
    def confirm
      response, api_key = Octobat.request(:patch, confirm_url, @api_key)
      refresh_from(response, api_key)
    end

    private

      def pay_url
        url + '/pay'
      end
    
      def send_url
        url + '/send'
      end
      
      def confirm_url
        url + '/confirm'
      end
  end
end
