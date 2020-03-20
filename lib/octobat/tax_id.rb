module Octobat
  class TaxId < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def archive
      response, api_key = Octobat.request(:patch, archive_url, @api_key)
      refresh_from(response, api_key)
    end

    private
      def archive_url
        url + '/archive'
      end
  end
end
