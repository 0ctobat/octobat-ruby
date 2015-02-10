module Octobat
  class APIResource < OctobatObject
    def self.class_name
      self.name.split('::')[-1]
    end

    def self.url
      if self == APIResource
        raise NotImplementedError.new('APIResource is an abstract class.  You should perform actions on its subclasses (Invoice, Customer, etc.)')
      end
      "/#{CGI.escape(class_name.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase)}s"
    end

    def url
      unless id = self['id']
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.url}/#{CGI.escape(id)}"
    end

    def refresh
      response, api_key = Octobat.request(:get, url, @api_key, @retrieve_options)
      refresh_from(response, api_key)
    end

    def self.retrieve(id, api_key=nil)
      instance = self.new(id, api_key)
      instance.refresh
      instance
    end
  end
end
