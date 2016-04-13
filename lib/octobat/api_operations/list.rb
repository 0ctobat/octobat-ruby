module Octobat
  module APIOperations
    module List
      def list(filters={}, opts={})
        api_key, headers = Util.parse_opts(opts)
        api_key ||= @api_key
        
        #opts = Util.normalize_opts(opts)
        #opts = @opts.merge(opts) if @opts
        
        response, api_key = Octobat.request(:get, url, api_key, filters, headers)
        obj = ListObject.construct_from(response, api_key)
        
        obj.filters = filters.dup
        obj.cursors[:ending_before] = obj.filters.delete(:ending_before)
        obj.cursors[:starting_after] = obj.filters.delete(:starting_after)
        
        
        obj
      end
      
      alias :all :list
    end
  end
end
