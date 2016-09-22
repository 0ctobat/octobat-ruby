module Octobat
  class TaxRegionSetting < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Update
    include Octobat::APIOperations::Create

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
