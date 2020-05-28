module Octobat
  class Order < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Update
    
    def expire(params = {}, opts = {})
      response, api_key = Octobat.request(:patch, expire_url, @api_key, params, opts)
      refresh_from(response, api_key)
    end

    private
      def expire_url
        url + '/expire'
      end

  end
end
