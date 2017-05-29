module Octobat
  class BalanceTransaction < APIResource
    extend Octobat::APIOperations::List
    
    def url
      puts parent_obj
      !parent_obj.nil? ? parentize_url : super
    end
    
    def parentize_url
      if parent_obj.include?(:payout)
        "#{Payout.url}/#{CGI.escape(parent_obj[:payout])}/balance_transactions/#{CGI.escape(id)}"
      else
        url
      end
    end
    
    def self.url
      if @parent_resource.include?(:payout)
        "#{Payout.url}/#{CGI.escape(@parent_resource[:payout])}/balance_transactions"
      end
    end

    def self.set_parent_resource(filters)
      @parent_resource = filters.select{|k, v| [:payout].include?(k)}
    end
    
  end
end
