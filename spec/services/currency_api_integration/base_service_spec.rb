# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrencyApiIntegration::BaseService, type: :service do
  context "Validate correct url" do
    let!(:transaction_attr) { attributes_for(:transaction, from_currency: 'USD', to_currency: 'EUR') }

    let(:route) do
      sprintf('latest?base_currency=%s&currencies=%s', transaction_attr[:from_currency], transaction_attr[:to_currency])
    end

    let(:url) do
      "http://api.currencyapi.com/v3/latest?#{route}&apikey=api_key"
    end

    let(:klass) do
      described_class.new.request_api(route)
    end

    let(:response) do
      {
        "meta": {
          "last_updated_at": "2023-06-23T10:15:59Z"
        },
        "data": {
          "AED": {
            "code": "EUR",
            "value": 3.67306
          }
        }
      }
    end
    it "should be return correct url" do
      allow_any_instance_of(described_class).to receive(:request_api).with(route).and_return(url)
      allow(HTTParty).to receive(:get).with(:url).and_return(response)

      expect(klass).to eq(url)
    end
  end
end
