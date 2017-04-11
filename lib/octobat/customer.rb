module Octobat
  class Customer < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update
    include Octobat::APIOperations::Delete

    def invoices(params = {})
      Invoice.all(params.merge({ :customer => id }), @api_key)
    end

    def credit_notes(params = {})
      CreditNote.all(params.merge({ :customer => id }), @api_key)
    end

    def payment_sources(params = {})
      PaymentSource.all(params.merge({ :customer => id }), @api_key)
    end

    def delete
      response, api_key = Octobat.request(:delete, url, @api_key)
      refresh_from(response, api_key)
    end

  end
end
