module Octobat
  class TaxEvidenceRequest < APIResource
    include Octobat::APIOperations::Create
    
    def self.for_supplier(params = {}, opts={})
      api_key, headers = Util.parse_opts(opts)
      api_key ||= @api_key
      opts[:api_key] = api_key

      instance = self.new(nil, opts)

      response, api_key = Octobat.request(:post, url + '/for_supplier', api_key, params, opts)
      instance.refresh_from(response, api_key)
      instance
    end
  end
end
