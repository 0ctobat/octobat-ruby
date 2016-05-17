module Octobat
  class InvalidRequestError < OctobatError

    def initialize(error, http_status=nil, http_body=nil, json_body=nil)
      super(error, http_status, http_body, json_body)
    end
  end
end
