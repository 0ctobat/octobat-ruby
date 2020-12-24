module Octobat
  class UsageItem < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Delete
    
    
    def url
      !parent_obj.nil? ? parentize_url : super
    end
    
    
    def save_url
      if self[:id] == nil && self.class.respond_to?(:create)
        self.relative_save_url
      else
        url
      end
    end
    
    
    def parentize_url
      if parent_obj.include?(:subscription)
        "#{Subscription.url}/#{CGI.escape(parent_obj[:subscription])}/usage_items/#{CGI.escape(id)}"
      else
        url
      end
    end
    
    
    
    def relative_save_url
      if self[:subscription]
        "#{Subscription.url}/#{CGI.escape(self[:subscription])}/usage_items"
      end
    end
    

    def self.url
      if @parent_resource.include?(:subscription)
        "#{Subscription.url}/#{CGI.escape(@parent_resource[:subscription])}/usage_items"
      end
    end

    def self.set_parent_resource(filters)
      @parent_resource = filters.select{|k, v| [:subscription].include?(k)}
    end
    
    
  end
end
