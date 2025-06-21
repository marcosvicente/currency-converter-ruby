# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrencyApiIntegration::BaseService, type: :service do
  context "Validate correct url" do
    let!(:transaction_attr) { attributes_for(:transaction, from_currency: 'USD', to_currency: 'EUR') }

    let(:route) do
      sprintf('base_currency=%s&currencies=%s', transaction_attr[:from_currency], transaction_attr[:to_currency])
    end

    let(:url) do
      "#{ENV['CURRENCYAPI_BASE_URL']}#{route}&apikey=#{ENV['CURRENCYAPI_TOKEN']}"
    end

    let(:klass) do
      described_class.new
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

   

    context "fetch correct values" do
      before do
        allow(HTTParty).to receive(:get).and_return(response)
        allow_any_instance_of(described_class).to receive(:request_api).with(route).and_return(response)
      end

      it 'fetches HTTParty current_api api' do

      stub_request(:get, url).
        to_return(status: 200, body: response.to_json, headers: {})

        expect(klass.request_api(route)).to eq(response)
      end

      it "should be return correct url" do
        expect(klass.get_url(route)).to eq(url)
      end
    end

    context "fetch incorrect values" do
      before do
        allow_any_instance_of(described_class).to receive(:request_api).with(route).and_raise
      end

      it 'fetches error with HTTParty::Error' do
        stub_request(:get, url)
          .to_return(status: 200, body: response.to_json, headers: {})
          .to_raise(HTTParty::ResponseError)
      end
    end
  end
end
