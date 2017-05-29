module Octobat
  class ListObject < OctobatObject
    include Enumerable
    include Octobat::APIOperations::List
    
    attr_accessor :filters, :cursors, :parent_resource
    
    def initialize(*args)
      super
      self.filters = {}
      self.cursors = {}
      self.parent_resource = {}
    end

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
    
    def empty?
      self.data.empty?
    end

    def retrieve(id, opts={})
      api_key, headers = Util.parse_opts(opts)
      api_key ||= @api_key
      
      if id.kind_of?(Hash)
        retrieve_options = id.dup
        retrieve_options.delete(:id)
        id = id[:id]
      else
        retrieve_options = {}
      end
      
      headers = {}
      
      retrieve_options.merge!(opts.clone).delete(:api_key)
      headers['Octobat-Version'] = retrieve_options.delete('Octobat-Version') if retrieve_options.has_key?('Octobat-Version')
            
      response, api_key = Octobat.request(:get, "#{url}/#{CGI.escape(id)}", api_key, retrieve_options, headers)
      Util.convert_to_octobat_object(response, api_key, self.parent_resource)
    end

    def create(params={}, opts={})
      api_key, headers = Util.parse_opts(opts)
      api_key ||= @api_key
      response, api_key = Octobat.request(:post, url, api_key, params, headers)
      Util.convert_to_octobat_object(response, api_key)
    end

    
    def next_page_params(params={}, opts={})
      return nil if !has_more
      last_id = data.last.id
      
      params = filters.merge({
        starting_after: last_id
      }).merge(params)
    end


    def previous_page_params(params={}, opts={})
      return nil if !has_before
      first_id = data.first.id

      params = filters.merge({
        ending_before: first_id
      }).merge(params)
    end
    
    
    def url
      self.request_url
    end
    
  end
end
