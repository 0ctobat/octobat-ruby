module Octobat
  class ProformaInvoice < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
  end
end
