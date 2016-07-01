module Octobat
  class TaxRegion < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def activate
      response, api_key = Octobat.request(:patch, activate_url, @api_key)
      refresh_from(response, api_key)
    end

    def unactivate
      response, api_key = Octobat.request(:patch, unactivate_url, @api_key)
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
