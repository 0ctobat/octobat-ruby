module Octobat
  module Beanie
    class Session < APIResource
      include Octobat::APIOperations::Create
      extend Octobat::APIOperations::List
      
      def self.url
        '/beanie/sessions'
      end
      
    end
  end
end