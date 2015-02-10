module Octobat
  class Invoice < APIResource
    include Octobat::APIOperations::List
    include Octobat::APIOperations::Create

    def pay(payment_data)
      response, api_key = Octobat.request(:patch, pay_url, @api_key, {payment: payment_data})
      refresh_from(response, api_key)
    end

    private

    def pay_url
      url + '/pay'
    end
  end
end
