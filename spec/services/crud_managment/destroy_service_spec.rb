# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CrudManagment::DestroyService, type: :service do
  context "call create with correct values" do
    context "should be destroy with valid params" do
      let!(:user) { create(:user) }
      let(:transaction) { create(:transaction, user_id: user.id) }

      let(:params) do
        {
          user_id:  transaction.user_id
        }
      end
      let(:klass) { described_class.new(Transaction, params).call }
      let(:render_json) { described_class.new(Transaction, params).render_json }

      it "should be return correct status" do
        expect(render_json[:status_code]).to eq(201)
      end

      it "should destroy a new transaction" do
        expect(Transaction.count).to eq(0)
      end
    end

     context "should be not destroy with valid params" do
      let!(:user) { create(:user) }
      let(:transaction) { nil }

      let(:params) do
        {
          user_id:  user.id
        }
      end
      let(:klass) { described_class.new(Transaction, params).call }
      let(:render_json) { described_class.new(Transaction, params).render_json }

      it "should be return correct status" do
        expect(render_json[:status_code]).to eq(404)
      end

      it "should be return correct message" do
        expect(render_json[:data]).to eq('Not have data')
      end
    end
  end
end
