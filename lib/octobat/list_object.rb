module Octobat
  class ListObject < OctobatObject

    def [](k)
      case k
      when String, Symbol
        super
      else
        raise ArgumentError.new("You tried to access the #{k.inspect} index, but ListObject types only support Octobat keys. (HINT: List calls return an object with a 'data' (which is the data array). You likely want to call #data[#{k.inspect}])")
      end
    end

    def each(&blk)
      self.data.each(&blk)
    end

    def retrieve(id, api_key=nil)
      api_key ||= @api_key
      response, api_key = Octobat.request(:get,"#{url}/#{CGI.escape(id)}", api_key)
      Util.convert_to_octobat_object(response, api_key)
    end

    def create(params={}, opts={})
      api_key, headers = Util.parse_opts(opts)
      api_key ||= @api_key
      response, api_key = Octobat.request(:post, url, api_key, params, headers)
      Util.convert_to_octobat_object(response, api_key)
    end

    def all(params={}, opts={})
      api_key, headers = Util.parse_opts(opts)
      api_key ||= @api_key
      response, api_key = Octobat.request(:get, url, api_key, params, headers)
      Util.convert_to_octobat_object(response, api_key)
    end
  end
end
