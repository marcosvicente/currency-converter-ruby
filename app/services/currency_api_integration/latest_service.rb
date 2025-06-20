module CurrencyApiIntegration
  class LatestService < CurrencyApiIntegration::BaseService
    def initialize(baseCurrency, currencies)
      @baseCurrency = baseCurrency
      @currencies = currencies
    end

    def call
      @result = request_api(sprintf('latest?base_currency=%s&currencies=%s', @baseCurrency, @currencies))
    end
  end
end