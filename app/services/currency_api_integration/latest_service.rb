module CurrencyApiIntegration
  class LatestService < CurrencyApiIntegration::BaseService
    def initialize(base_currency, currencies)
      @base_currency = base_currency
      @currencies = currencies
    end

    def call
      get_values_from_currency(get_route)
    end

    def get_route
      request_api(sprintf("latest?base_currency=%s&currencies=%s", @base_currency, @currencies))
    end

    def get_values_from_currency(result)
      if result["data"].nil?
        raise result["message"]
      end

      result["data"][@currencies]["value"]
    end
  end
end
