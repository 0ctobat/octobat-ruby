module Octobat
  module APIOperations
    module List
      def list(filters={}, opts={})
        parent_resource(filters)

        api_key, headers = Util.parse_opts(opts)
        api_key ||= @api_key

        f = filters.select{|request_filter| !@parent_resource.has_key?(request_filter)}

        response, api_key = Octobat.request(:get, url, api_key, f, headers)
        obj = ListObject.construct_from(response, api_key)

        obj.filters = filters.dup
        obj.cursors[:ending_before] = obj.filters.delete(:ending_before)
        obj.cursors[:starting_after] = obj.filters.delete(:starting_after)

        obj.filters.delete(:expand)

        obj
      end

      def parent_resource(filters)
        @parent_resource = {}
      end

      alias :all :list
    end
  end
end
