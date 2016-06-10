module Octobat
  class Item < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update
    
    def save_url
      if self[:id] == nil && self.class.respond_to?(:create)
        self.relative_save_url
      else
        url
      end
    end
    
    
    def relative_save_url
      puts self.inspect
      
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

    def self.parent_resource(filters)
      @parent_resource = filters.select{|k, v| [:transaction, :invoice, :credit_note].include?(k)}
    end
  end
end
