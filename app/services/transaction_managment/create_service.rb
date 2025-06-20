module TransactionManagment
  class CreateService < CrudManagment::CreateService
    def initialize(klass, params)
      super
    end

    def load_object
      currency_api_value = get_values_from_currency
      @klass = @klass.new(
        user_id: params[:user_id],
        from_currency: params[:from_currency],
        to_currency: params[:to_currency],
        from_value: params[:from_value],
        to_value: currency_api_value,
        rate: currency_api_value / params[:from_value]
      )
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