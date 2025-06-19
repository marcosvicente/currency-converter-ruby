# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CrudManagment::ShowService, type: :service do
  context "call index with correct values" do
    let!(:transactions) { create_list(:transaction, 10) }

    context "should be returned with correct value of model with param" do
      let(:params) do
        {
          user_id: transactions[5].user_id
        }
      end

      let(:klass) { described_class.new(Transaction, params).call }
      let(:transaction_show_value) { Transaction.find_by(user_id: transactions[5].user_id) }

      it "validate values" do
        expect(klass.id).to eq(transaction_show_value.id)
        expect(klass.from_currency).to eq(transaction_show_value.from_currency)
        expect(klass.from_value).to eq(transaction_show_value.from_value)
        expect(klass.rate).to eq(transaction_show_value.rate)
        expect(klass.to_currency).to eq(transaction_show_value.to_currency)
        expect(klass.to_value).to eq(transaction_show_value.to_value)
        expect(klass.user_id).to eq(transaction_show_value.user_id)
      end
    end
  end
end
