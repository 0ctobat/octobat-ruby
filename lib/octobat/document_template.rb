module Octobat
  class DocumentTemplate < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def duplicate(params = {}, opts = {})
      response, api_key = Octobat.request(:post, duplicate_url, @api_key, params, opts)
      refresh_from(response, api_key)
    end

    def activate(params = {}, opts = {})
      response, api_key = Octobat.request(:patch, activate_url, @api_key, params, opts)
      refresh_from(response, api_key)
    end

    def delete(params = {}, opts = {})
      response, api_key = Octobat.request(:delete, url, @api_key, params, opts)
      refresh_from(response, api_key)
    end
    
    def preview(params = {}, opts = {})
      response, api_key = Octobat.request(:get, preview_url, @api_key, params, opts)
      refresh_from(response, api_key)
    end

    private

      def duplicate_url
        url + '/duplicate'
      end

      def activate_url
        url + '/activate'
      end
      
      def preview_url
        url + '/preview'
      end

  end
end
