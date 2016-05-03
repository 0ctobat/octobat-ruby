module Octobat
  class Transaction < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create

    def items(params = {})
      Item.list(params.merge({ :transaction => id }), @api_key)
    end
    # oc_txn_14605672518yko2fd30d23
  end
end
