module Octobat
  class Transaction < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create

    def items(params = {})
      Item.list(params.merge({ :transaction => id }), @api_key)
    end
  end
end
