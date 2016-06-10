module Octobat
  class TaxRegion < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update
  end
end
