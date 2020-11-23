module Octobat
  class Customer < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update
    include Octobat::APIOperations::Delete

    def invoices(params = {}, opts = {})
      Invoice.list(params.merge({ :customer => id }), {api_key: @api_key}.merge(opts))
    end

    def credit_notes(params = {}, opts = {})
      CreditNote.list(params.merge({ :customer => id }), {api_key: @api_key}.merge(opts))
    end

    def payment_sources(params = {}, opts = {})
      PaymentSource.list(params.merge({ :customer => id }), {api_key: @api_key}.merge(opts))
    end
    
    def customer_balance_transactions(params = {}, opts = {})
      CustomerBalanceTransaction.list(params.merge({ :customer => id }), {api_key: @api_key}.merge(opts))
    end
    
  end
end
