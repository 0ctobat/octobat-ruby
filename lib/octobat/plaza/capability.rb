module Octobat
  module Plaza
    class Capability < Octobat::APIResource
      extend Octobat::APIOperations::List

      def url
        !parent_obj.nil? ? parentize_url : super
      end

      def ask(params = {}, opts = {})
        response, api_key = Octobat.request(:patch, ask_url, @api_key, params, opts)
        refresh_from(response, api_key)
      end
      
      def save_url
        if self[:id] == nil && self.class.respond_to?(:create)
          self.relative_save_url
        else
          url
        end
      end
      
      
      def parentize_url
        if parent_obj.include?(:account)
          "#{Account.url}/#{CGI.escape(parent_obj[:account])}/capabilities/#{CGI.escape(id)}"
        else
          url
        end
      end
      
      
      
      def relative_save_url
        if self[:account]
          "#{Account.url}/#{CGI.escape(self[:account])}/capabilities"
        end
      end

      def ask_url
        "#{parentize_url}/request"
      end
      
      def self.url
        if @parent_resource.include?(:account)
          "#{Account.url}/#{CGI.escape(@parent_resource[:account])}/capabilities"
        end
      end
  
      def self.set_parent_resource(filters)
        @parent_resource = filters.select{|k, v| [:account].include?(k)}
      end
  
    end
  end
end