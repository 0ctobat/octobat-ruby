module Octobat
  class PaymentSource < APIResource
    extend Octobat::APIOperations::List
    include Octobat::APIOperations::Create

    def self.url
      if @parent_resource.include?(:customer)
        "#{Customer.url}/#{CGI.escape(@parent_resource[:customer])}/payment_sources"
      end
    end

    def self.parent_resource(filters)
      @parent_resource = filters.select{|k, v| [:customer].include?(k)}
    end
  end
end
