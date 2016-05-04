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

# item = i.items.create(
#   tax_evidence: "oc_tev_1460565379am3be8f5ef71",
#   quantity: 1,
#   currency: "USD",
#   unit_extratax_amount: 19900,
#   description: "Entreprise Plan"
# )
# item.save
