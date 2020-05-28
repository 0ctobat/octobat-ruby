module Octobat
  class InvoiceNumberingSequence < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def set_to_default(params = {}, opts = {})
      response, api_key = Octobat.request(:patch, set_to_default_url, @api_key, params, opts)
      refresh_from(response, api_key)
    end

    private

      def set_to_default_url
        url + '/default'
      end
  end
end
