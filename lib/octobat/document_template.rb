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
    
    def self.preview(params = {}, opts={})
      api_key, headers = Util.parse_opts(opts)
      api_key ||= @api_key
      opts[:api_key] = api_key

      instance = self.new(nil, opts)

      response, api_key = Octobat.request(:get, url + '/preview', api_key, params)
      instance.refresh_from(response, api_key)
      instance
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
