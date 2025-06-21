
require 'rails_helper'

RSpec.describe CurrencyApiIntegration::LatestService, type: :service do
  context "Validate correct url" do
    let!(:transaction_attr) { attributes_for(:transaction, from_currency: 'USD', to_currency: 'EUR') }

    let(:route) do
      sprintf('latest?base_currency=%s&currencies=%s', transaction_attr[:from_currency], transaction_attr[:to_currency])
    end

    let(:url) do
      "http://api.currencyapi.com/v3/latest?#{route}&apikey=api_key"
    end

    let(:klass) do
      described_class.new(transaction_attr[:from_currency], transaction_attr[:to_currency])
    end

    let(:value) { 52.000 }
    let(:currency_api_response) do
        {
          "meta": {
            "last_updated_at": "2023-06-23T10:15:59Z"
          },
          "data": {
            "EUR": {
              "code": "EUR",
              "value": value
            }
          }
        }
      end

    it "should be return correct url" do
      allow_any_instance_of(CurrencyApiIntegration::BaseService).to receive(:request_api).with(route).and_return(url)

      expect(klass.get_url).to eq(url)
    end

      it "should be return correct value from currency_api" do
      allow_any_instance_of(CurrencyApiIntegration::BaseService).to receive(:request_api).with(route).and_return(url)
      allow_any_instance_of(described_class).to receive(:get_values_from_currency).with(url).and_return(currency_api_response)

      expect(klass.get_values_from_currency(url)).to eq(currency_api_response)
    end
  end
end
