module Octobat
  class Item < APIResource
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
      if parent_obj.include?(:transaction)
        "#{Transaction.url}/#{CGI.escape(parent_obj[:transaction])}/items/#{CGI.escape(id)}"
      elsif parent_obj.include?(:invoice)
        "#{Invoice.url}/#{CGI.escape(parent_obj[:invoice])}/items/#{CGI.escape(id)}"
      elsif parent_obj.include?(:credit_note)
        "#{CreditNote.url}/#{CGI.escape(parent_obj[:credit_note])}/items/#{CGI.escape(id)}"
      else
        url
      end
    end
    
    
    
    def relative_save_url
      if self[:transaction]
        "#{Transaction.url}/#{CGI.escape(self[:transaction])}/items"
      elsif self[:invoice]
        "#{Invoice.url}/#{CGI.escape(self[:invoice])}/items"
      elsif self[:credit_note]
        "#{CreditNote.url}/#{CGI.escape(self[:credit_note])}/items"
      end
    end
    

    def self.url
      if @parent_resource.include?(:transaction)
        "#{Transaction.url}/#{CGI.escape(@parent_resource[:transaction])}/items"
      elsif @parent_resource.include?(:invoice)
        "#{Invoice.url}/#{CGI.escape(@parent_resource[:invoice])}/items"
      elsif @parent_resource.include?(:credit_note)
        "#{CreditNote.url}/#{CGI.escape(@parent_resource[:credit_note])}/items"
      end
    end

    def self.set_parent_resource(filters)
      @parent_resource = filters.select{|k, v| [:transaction, :invoice, :credit_note].include?(k)}
    end
    
    
  end
end
