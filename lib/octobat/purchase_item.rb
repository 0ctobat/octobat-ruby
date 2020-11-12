module Octobat
  class PurchaseItem < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update
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
      if parent_obj.include?(:self_billing_invoice)
        "#{SelfBillingInvoice.url}/#{CGI.escape(parent_obj[:self_billing_invoice])}/purchase_items/#{CGI.escape(id)}"
      else
        url
      end
    end
    
    
    
    def relative_save_url
      if self[:self_billing_invoice]
        "#{SelfBillingInvoice.url}/#{CGI.escape(self[:self_billing_invoice])}/purchase_items"
      end
    end
    

    def self.url
      if @parent_resource.include?(:self_billing_invoice)
        "#{SelfBillingInvoice.url}/#{CGI.escape(@parent_resource[:self_billing_invoice])}/purchase_items"
      end
    end

    def self.set_parent_resource(filters)
      @parent_resource = filters.select{|k, v| [:self_billing_invoice].include?(k)}
    end
    
    
  end
end
