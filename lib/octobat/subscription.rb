module Octobat
  class Subscription < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create
    
    def usage_items(params = {}, opts = {})
      UsageItem.list(params.merge({ subscription: id }), { api_key: @api_key }.merge(opts))
    end

  end


end
