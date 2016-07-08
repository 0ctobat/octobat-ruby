module Octobat
  module APIOperations
    module Delete
      def delete(params = {}, opts={})
        api_key, headers = Util.parse_opts(opts)
        
        response, api_key = Octobat.request(:delete, url, api_key || @api_key, params, headers)
        refresh_from(response, api_key)
      end
    end
  end
end
