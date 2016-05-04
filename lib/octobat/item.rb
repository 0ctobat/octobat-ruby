module Octobat
  class Item < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update


    def self.list(filters={}, opts={})

      url = if filters.include?(:transaction)
        "#{Transaction.url}/#{CGI.escape(filters[:transaction])}/items"
      elsif filters.include?(:invoice)
        "#{Invoice.url}/#{CGI.escape(filters[:invoice])}/items"
      elsif filters.include?(:credit_note)
        "#{CreditNote.url}/#{CGI.escape(filters[:credit_note])}/items"
      else
        "diallo"
      end


      api_key, headers = Util.parse_opts(opts)
      api_key ||= @api_key

      #opts = Util.normalize_opts(opts)
      #opts = @opts.merge(opts) if @opts

      response, api_key = Octobat.request(:get, url, api_key, filters, headers)
      obj = ListObject.construct_from(response, api_key)

      obj.filters = filters.dup
      obj.cursors[:ending_before] = obj.filters.delete(:ending_before)
      obj.cursors[:starting_after] = obj.filters.delete(:starting_after)


      obj
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
