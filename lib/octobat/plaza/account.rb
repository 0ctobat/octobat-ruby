module Octobat
  module Plaza
    class Account < Octobat::APIResource
      extend Octobat::APIOperations::List
      include Octobat::APIOperations::Create
      include Octobat::APIOperations::Update

      def self.url
        '/plaza/accounts'
      end

      def activate(params = {}, opts = {})
        response, api_key = Octobat.request(:patch, activate_url, @api_key, params, opts)
        refresh_from(response, api_key)
      end
  
      def deactivate(params = {}, opts = {})
        response, api_key = Octobat.request(:patch, deactivate_url, @api_key, params, opts)
        refresh_from(response, api_key)
      end

      def list_capabilities(params = {}, opts = {})
        Capability.list(params.merge({ :account => id }), {api_key: @api_key}.merge(opts))
      end
  

      private
      def activate_url
        url + '/activate'
      end

      def deactivate_url
        url + '/deactivate'
      end

  
    end
  end
end