# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrencyApiIntegration::BaseService, type: :service do
  context "Validate correct url" do
    let!(:transaction_attr) { attributes_for(:transaction, from_currency: 'USD', to_currency: 'EUR') }

    let(:route) do
      sprintf('latest?base_currency=%s&currencies=%s', transaction_attr[:from_currency], transaction_attr[:to_currency])
    end

    let(:url) do
      "#{ENV['CURRENCYAPI_BASE_URL']}#{route}&apikey=#{ENV['CURRENCYAPI_TOKEN']}"
    end

    let(:klass) do
      described_class.new
    end

    let(:currency_api_response) do
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

    let(:currency_api_response_error) { { "message": "Error" } }

    context "fetch correct values" do
      before do
        allow(HTTParty).to receive(:get).and_return(currency_api_response.deep_stringify_keys)
      end

      it 'fetches HTTParty current_api' do
        klass.request_api(route)
        expect(HTTParty).to have_received(:get).once
      end

      it "should be return correct url" do
        expect(klass.get_url(route)).to eq(url)
      end
    end

    context "fetch incorrect values" do
      before do
        allow(HTTParty).to receive(:get).and_raise(HTTParty::Error)
      end

      it 'fetches error with HTTParty::Error' do
        expect { klass.request_api(route) }.to raise_error(HTTParty::Error)
      end
    end
  end
end
