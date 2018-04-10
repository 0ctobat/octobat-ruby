module Octobat
  class Payout < APIResource
    extend Octobat::APIOperations::List
    
    def balance_transactions(params = {})
      BalanceTransaction.list(params.merge({ payout: id }), @api_key)
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
