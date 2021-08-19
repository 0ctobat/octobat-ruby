module Octobat
  module Plaza
    class CountrySpec < Octobat::APIResource
      extend Octobat::APIOperations::List
      
      def self.url
        '/plaza/country_specs'
      end
  
    end
  end
end