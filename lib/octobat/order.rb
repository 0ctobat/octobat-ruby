module Octobat
  class Order < APIResource
    extend Octobat::APIOperations::List
    
    def expire
      response, api_key = Octobat.request(:patch, expire_url, @api_key)
      refresh_from(response, api_key)
    end

    def update_payment_intent_status(payment_intent_status_data = {})
      response, api_key = Octobat.request(:patch, update_payment_intent_status_url, @api_key, payment_intent_status_data)
      refresh_from(response, api_key)
    end
    
    def update_setup_intent_status(setup_intent_status_data = {})
      response, api_key = Octobat.request(:patch, update_setup_intent_status_url, @api_key, setup_intent_status_data)
      refresh_from(response, api_key)
    end
    

    private
      def expire_url
        url + '/expire'
      end

      def update_payment_intent_status_url
        url + '/payment_intent_status'
      end
      
      def update_setup_intent_status_url
        url + '/setup_intent_status'
      end

  end


end
