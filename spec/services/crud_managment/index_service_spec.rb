require 'rails_helper'

RSpec.describe CrudManagment::IndexService, type: :service do

  context "call index with correct values" do
    let!(:user) { create(:user) }
    let!(:transactions) { create_list(:transaction, 10, user: user) }

    context "should be returned with correct value of model" do
      let(:order) { "created_at asc"}
      let(:paginate_params) do
        {
          page: 1,
          per_page: 7
        }
      end

      let(:params) do
        {
          user_id: 1
        }
      end

      let(:klass) { described_class.new(Transaction, params, paginate_params, order).call }

      it "validate values" do
        klass.each_with_index do |list, index|
          expect(list.from_currency).to eq(transactions[index].from_currency)
          expect(list.from_value).to eq(transactions[index].from_value)
          expect(list.rate).to eq(transactions[index].rate)
          expect(list.to_currency).to eq(transactions[index].to_currency)
          expect(list.to_value).to eq(transactions[index].to_value)
          expect(list.user_id.to_i).to eq(transactions[index].user_id)
        end
      end
    end

    context "should be return with pagination" do
      let(:paginate_params) do
        {
          page: 1,
          per_page: 7
        }
      end

      let(:paginate2_params) do
        {
          page: 2,
          per_page: 7
        }
      end
      let(:klass_per_page) { described_class.new(Transaction, nil, paginate_params, nil).call }
      let(:klass_page) { described_class.new(Transaction, nil, paginate2_params, nil).call }

      it "with correct per_page" do
        expect(klass_per_page.count).to eq(7)
      end
      it "with correct page" do
        expect(klass_page.count).to eq(3)
      end
    end


    context "should be return with order" do
      let(:order) { "created_at desc"}
      let(:transaction_order_validate) { Transaction.order(created_at: :desc).first.id }

      let(:klass) { described_class.new(Transaction, nil, nil, order).call }

      it "created_at desc" do
        expect(klass.first.id).to eq(transaction_order_validate)
      end
    end

    context "should be return with params" do
      context "with all" do
        let(:klass) { described_class.new(Transaction, nil, nil, nil).call}
        it "should be return all value of klass" do
          expect(klass.count).to eq(Transaction.count)
        end
      end

      context "with where" do
        let(:params) do
          {
            id: 1
          }
        end

        let(:klass) { described_class.new(Transaction, params, nil, nil).call }
        let(:klass_validated_where) { Transaction.where(id: 1) }

        it "should be return only has the id of klass" do
          expect(klass).to eq(klass_validated_where)
        end
      end
    end
  end
end