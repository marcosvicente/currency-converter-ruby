module CurrencyApiIntegration
  class BaseService
    def request_api(route)
      begin
        @response = HTTParty.get(
          "#{ENV['CURRENCYAPI_BASE_URL']}#{route}&apikey=#{ENV['CURRENCYAPI_TOKEN']}"
        )
      rescue HTTParty::Error, SocketError => e
        @data = e.response
      end
    end
  end
end