
require 'rails_helper'

RSpec.describe CurrencyApiIntegration::LatestService, type: :service do
  context "Validate correct url" do
    let!(:transaction_attr) { attributes_for(:transaction, from_currency: 'USD', to_currency: 'EUR') }

    let(:route) do
      sprintf('latest?base_currency=%s&currencies=%s',transaction_attr[:from_currency], transaction_attr[:to_currency])
    end

    let(:url) do
      "http://api.currencyapi.com/v3/latest?#{route}&apikey=api_key"
    end

    let(:klass) do
      described_class.new(transaction_attr[:from_currency], transaction_attr[:to_currency])
    end


    it "should be return correct url" do
      allow_any_instance_of(CurrencyApiIntegration::BaseService).to receive(:request_api).with(route).and_return(url)

      expect(klass.get_url).to eq(url)
    end
  end
end