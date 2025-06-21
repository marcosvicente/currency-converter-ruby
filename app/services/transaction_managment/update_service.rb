module TransactionManagment
  class UpdateService < CrudManagment::UpdateService
    def initialize(klass, params, item_params)
      super
    end

    def update
      @params
      super
    end

    def set_params
      super()
      currency_api_value = get_values_from_currency
      if @params[:from_currency] != @klass.from_currency || @params[:to_currency] != @klass.to_currency
        @params[:to_value] = currency_api_value
        @params[:rate] = currency_api_value / params[:from_value]
      end
      @params
    end

    def get_values_from_currency_api
      CurrencyApiIntegration::LatestService.new(
        @params[:from_currency],
        @params[:to_currency]
      ).call
    end

    def get_values_from_currency
      currency_api = get_values_from_currency_api

      currency_api["data"][@params[:to_currency]]["value"]
    end
  end
end