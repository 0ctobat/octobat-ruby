module Octobat
  class FileUpload < APIResource
    include Octobat::APIOperations::Create
    extend Octobat::APIOperations::List
    
    def self.url
      "/files"
    end
    
    
    def self.create(params = {}, opts = {})
      if params[:attachment] && !params[:attachment].is_a?(String)
        unless params[:attachment].respond_to?(:read)
          raise ArgumentError, "attachment must respond to `#read`"
        end
      end
      
      api_key, headers = Util.parse_opts(opts)
      headers = headers.merge(content_type: MultipartEncoder::MULTIPART_FORM_DATA)
      
      response, api_key = Octobat.request(:post, self.url, api_key, params, headers, Octobat.uploads_base)
      Util.convert_to_octobat_object(response, api_key)
      
    end
        
    def refresh
      response, api_key = Octobat.request(:get, url, @api_key, @retrieve_options, @headers, Octobat.uploads_base)
      refresh_from(response, api_key)
    end
    
    
    def self.list(filters={}, opts={})
      set_parent_resource(filters)
      api_key, headers = Util.parse_opts(opts)
      
      api_key ||= @api_key

      f = filters.select{|request_filter| !@parent_resource.has_key?(request_filter)}

      response, api_key = Octobat.request(:get, url, api_key, f, headers, Octobat.uploads_base)
      obj = ListObject.construct_from(response, api_key)

      obj.filters = filters.dup
      obj.cursors[:ending_before] = obj.filters.delete(:ending_before)
      obj.cursors[:starting_after] = obj.filters.delete(:starting_after)

      obj.filters.delete(:expand)
      obj.parent_resource = @parent_resource

      obj
    end

    
    
    
  end
end
