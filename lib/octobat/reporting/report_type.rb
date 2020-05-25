module Octobat
  module Reporting
    class ReportType < APIResource
      extend Octobat::APIOperations::List
      
      def self.url
        '/reporting/report_types'
      end
      
    end
  end
end