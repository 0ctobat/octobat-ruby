module Octobat
  class Transaction < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    include Octobat::APIOperations::Update

    def items(params = {})
      Item.list(params.merge({ :transaction => id }), @api_key)
    end
    
    def self.csv_export(params = {}, opts={})
      api_key, headers = Util.parse_opts(opts)
      api_key ||= @api_key
      opts[:api_key] = api_key

      instance = self.new(nil, opts)

      response, api_key = Octobat.request(:post, url + '/csv_export', api_key, params)
      return true
    end
    
  end
end
