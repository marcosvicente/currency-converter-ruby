module CurrencyApiIntegration
  class LatestService < CurrencyApiIntegration::BaseService
    def initialize(baseCurrency, currencies)
      @baseCurrency = baseCurrency
      @currencies = currencies
    end

    def call
      result = get_url
      get_values_from_currency(result)
    end

    def get_url
      request_api(sprintf('latest?base_currency=%s&currencies=%s', @baseCurrency, @currencies))
    end

    def get_values_from_currency(result)
      if result["data"].nil
        raise result["message"]
      end

      result["data"][@params[:to_currency]]["value"]
    end
  end
end