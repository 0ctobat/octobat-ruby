module Octobat
  class Transaction < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def items(params = {})
      Item.list(params.merge({ :transaction => id }), @api_key)
    end
  end
end
