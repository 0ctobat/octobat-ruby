module Octobat
  module Reporting
    class ReportRun < APIResource
      include Octobat::APIOperations::Create
      extend Octobat::APIOperations::List
      
      def self.url
        '/reporting/report_runs'
      end
    end
  end
end