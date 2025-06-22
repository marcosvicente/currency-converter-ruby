module CurrencyApiIntegration
  class BaseService
    def request_api(route)
      begin
        @response = HTTParty.get(get_url(route))
      rescue HTTParty::Error => e
        Rails.logger.error "Error request: #{e}"
        raise e
      end
    end

    def get_url(route)
      "#{ENV['CURRENCYAPI_BASE_URL']}#{route}&apikey=#{ENV['CURRENCYAPI_TOKEN']}"
    end
  end
end
