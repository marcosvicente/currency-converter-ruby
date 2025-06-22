# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionManagment::UpdateService, type: :service do
  context "call create with correct values" do
    context "should be returned with valid params" do
      let!(:user) { create(:user) }
      let(:transaction) { create(:transaction, user_id: user.id, from_currency: CurrencyEnumeration::BRL) }
      let(:transaction_attr) { attributes_for(:transaction, user_id: user.id, from_currency: CurrencyEnumeration::EUR) }

      let(:item_params) do
        {
          user_id:  transaction.user_id
        }
      end

      let(:klass) { described_class.new(Transaction, transaction_attr, item_params)}
      let(:klass_call) { klass.call }
      let(:render_json) { described_class.new(Transaction, transaction_attr, item_params).render_json }

      let(:value) { 3.67306 }

      let(:latest_service) { instance_double(CurrencyApiIntegration::LatestService) }
      before(:each) do
        allow(CurrencyApiIntegration::LatestService).to receive(:new).with(
          transaction_attr[:from_currency],
          transaction_attr[:to_currency]
        ).and_return(latest_service)
        allow(latest_service).to receive(:call).and_return(value)
      end

      it "should be return correct status" do
        expect(render_json[:status_code]).to eq(201)
      end

      it "should be receive CurrencyApiIntegration::LatestService" do
        klass.get_values_from_currency_api
        expect(latest_service).to have_received(:call)
      end

      it "should be return value of get_values_from_currency_api" do
        expect(klass.get_values_from_currency_api).to eq(value)
      end

      it "should update a new transaction" do
        klass_call.reload
        expect(Transaction.count).to eq(1)
      end

      it "should validate correct values" do
        klass_call.reload
        expect(klass_call.from_currency).to eq(transaction_attr[:from_currency])
        expect(klass_call.from_value).to eq(transaction_attr[:from_value])
        expect(klass_call.to_value).to eq(value)
        expect(klass_call.rate).to eq(value / transaction_attr[:from_value])
        expect(klass_call.to_currency).to eq(transaction_attr[:to_currency])
        expect(klass_call.user_id).to eq(transaction_attr[:user_id])
      end

      context "should be returned with invalid params" do
        let(:transaction) { create(:transaction, user_id: user.id) }
        let!(:transaction_attr) { attributes_for(:transaction, to_currency: nil) }

        let(:item_params) do
          {
            user_id:  transaction.user_id
          }
        end

        let(:render_json) { described_class.new(Transaction, transaction_attr, item_params).render_json }

        let(:klass) { described_class.new(Transaction, transaction_attr, item_params).call }

        it "should not update a new transaction" do
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
