module Octobat
  class Payout < APIResource
    extend Octobat::APIOperations::List
    
    def balance_transactions(params = {})
      BalanceTransaction.list(params.merge({ payout: id }), @api_key)
    end
  end
end
