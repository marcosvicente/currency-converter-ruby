# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionManagment::CreateService, type: :service do
  context "call create with correct values" do

    context "should be returned with valid params" do
      let!(:user) { create(:user) }
      let(:transaction_attr) { attributes_for(:transaction, user_id: user.id) }
      let(:klass) { described_class.new(Transaction, transaction_attr).call }
      let(:render_json) { described_class.new(Transaction, transaction_attr).render_json }

      let(:value){ 3.67306 }

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

      before(:each) do
        allow(HTTParty).to receive(:get).and_return(currency_api_response)
        allow_any_instance_of(described_class).to receive(:get_values_from_currency).and_return(value)
      end

      it "should be return correct status" do
        expect(render_json[:status_code]).to eq(201)
      end

      it "should create a new transaction" do
        klass.reload
        expect(Transaction.count).to eq(1)
      end

      it "should validate correct values" do
        klass.reload
        expect(klass.from_currency).to eq(transaction_attr[:from_currency])
        expect(klass.from_value).to eq(transaction_attr[:from_value])
        expect(klass.rate).to eq(value / transaction_attr[:from_value])
        expect(klass.to_currency).to eq(transaction_attr[:to_currency])
        expect(klass.to_value).to eq(value)
        expect(klass.user_id).to eq(transaction_attr[:user_id])
      end

      context "should be returned with invalid params" do
        let!(:transaction_attr) { attributes_for(:transaction, to_currency: nil) }
        let(:render_json) { described_class.new(Transaction, transaction_attr).render_json }

        let(:klass) { described_class.new(Transaction, transaction_attr).call }

        it "should not create a new transaction" do
          expect(Transaction.count).to eq(0)
        end

        it "should be return correct status" do
          expect(render_json[:status_code]).to eq(422)
        end

        it "should return errors" do
          expect(klass.errors.full_messages).to include("To currency can't be blank")
        end
      end
    end
  end
end
