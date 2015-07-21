module Octobat
  class Customer < APIResource
    include Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update
    
    def invoices(params = {})
      Invoice.all(params.merge({ :customer => id }), @api_key)
    end
    
  end
end
