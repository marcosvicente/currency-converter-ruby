module Request
  module AuthHelpers
    def response_body(symbolize_keys: false)
      json = JSON.parse(response.body)
      symbolize_keys ? json.deep_symbolize_keys : json
    end
  end
end
