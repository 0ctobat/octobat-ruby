module Octobat
  class CustomerBalanceTransaction < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    
    
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
      if parent_obj.include?(:customer)
        "#{Customer.url}/#{CGI.escape(parent_obj[:customer])}/customer_balance_transactions/#{CGI.escape(id)}"
      else
        url
      end
    end
    
    
    
    def relative_save_url
      if self[:customer]
        "#{Customer.url}/#{CGI.escape(self[:customer])}/customer_balance_transactions"
      end
    end
    

    def self.url
      if @parent_resource.include?(:customer)
        "#{Customer.url}/#{CGI.escape(@parent_resource[:customer])}/customer_balance_transactions"
      end
    end

    def self.set_parent_resource(filters)
      @parent_resource = filters.select{|k, v| [:customer].include?(k)}
    end
    
    
  end
end
