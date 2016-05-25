module Octobat
  class DocumentTemplate < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def duplicate(params = {})
      response, api_key = Octobat.request(:post, duplicate_url, @api_key, params)
      refresh_from(response, api_key)
    end

    def activate
      response, api_key = Octobat.request(:patch, activate_url, @api_key)
      refresh_from(response, api_key)
    end

    def delete
      response, api_key = Octobat.request(:delete, url, @api_key)
      refresh_from(response, api_key)
    end

    private

      def duplicate_url
        url + '/duplicate'
      end

      def activate_url
        url + '/activate'
      end

  end
end
