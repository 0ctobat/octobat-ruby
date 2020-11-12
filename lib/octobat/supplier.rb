module Octobat
  class Supplier < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update
    include Octobat::APIOperations::Delete
  end
end
