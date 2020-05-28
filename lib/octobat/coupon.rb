module Octobat
  class Coupon < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def activate(params = {}, opts = {})
      response, api_key = Octobat.request(:patch, activate_url, @api_key, params, opts)
      refresh_from(response, api_key)
    end

    def unactivate(params = {}, opts = {})
      response, api_key = Octobat.request(:patch, unactivate_url, @api_key, params, opts)
      refresh_from(response, api_key)
    end

    def delete(params = {}, opts = {})
      response, api_key = Octobat.request(:delete, url, @api_key, params, opts)
      refresh_from(response, api_key)
    end
    

    private

      def activate_url
        url + '/activate'
      end

      def unactivate_url
        url + '/unactivate'
      end
  end
end
