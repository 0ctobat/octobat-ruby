module Octobat
  class Item < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

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
