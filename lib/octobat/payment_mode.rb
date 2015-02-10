module Octobat
  class PaymentMode < APIResource
    include Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update
  end
end
