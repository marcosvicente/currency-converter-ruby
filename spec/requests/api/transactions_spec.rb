require 'rails_helper'

RSpec.describe "Api::Transactions", type: :request do
  # GET /users
  describe "GET /index" do
  let!(:transactions) { create_list(:transaction, 10)}
    context "success" do
      it "should be return all transactions" do
        get "/api/transactions/"

        expect(response).to have_http_status(:success)
        expect(response_body).to be_an_instance_of(Array)

        transactions.each_with_index do |transaction, index|
          expect(response_body[index]["from_currency"]).to eq(transaction.from_currency)
          expect(response_body[index]["from_value"]).to eq(transaction.from_value)
          expect(response_body[index]["rate"]).to eq(transaction.rate)
          expect(response_body[index]["to_currency"]).to eq(transaction.to_currency)
          expect(response_body[index]["to_value"]).to eq(transaction.to_value)
          expect(response_body[index]["user_id"].to_i).to eq(transaction.user_id)
        end
      end

      it "should  be return all transaction with paginate" do
        get "/api/transactions/",
          params: { page: 2, per_page: 5 }

        expect(response).to have_http_status(:success)

        expect(response_body.size).to eq(5)
      end
    end
  end

  # GET /users/:user_id
  describe "GET /show" do
    context "success" do
      let!(:transactions) { create_list(:transaction, 10)}
      it "should be return transactions with user_id" do
        get "/api/transactions/#{transactions[3].user_id}"

        expect(response).to have_http_status(:success)
        expect(response_body["from_currency"]).to eq(transactions[3].from_currency)
        expect(response_body["from_value"]).to eq(transactions[3].from_value)
        expect(response_body["rate"]).to eq(transactions[3].rate)
        expect(response_body["to_currency"]).to eq(transactions[3].to_currency)
        expect(response_body["to_value"]).to eq(transactions[3].to_value)
        expect(response_body["user_id"].to_i).to eq(transactions[3].user_id)
      end
    end
  end

  # POST /users/
  context "POST /create" do
    let(:user) { create(:user) }
    let(:valid_attributes) do
      attributes_for(:transaction, user_id: user.id)
    end

    let(:invalid_attributes) do
      attributes_for(:transaction, name: "test")
    end

    let(:value){ 3.67306 }

    let(:currency_api_response) do
      {
        "meta": {
          "last_updated_at": "2023-06-23T10:15:59Z"
        },
        "data": {
          "AED": {
            "code": "EUR",
            "value": value
          }
        }
      }
    end

    before(:each) do
      allow(HTTParty).to receive(:get).and_return(currency_api_response)
      allow_any_instance_of(TransactionManagment::CreateService).to receive(:get_values_from_currency_api).and_return(value)
    end

    context "with valid parameters" do
      it "creates a new transaction" do
        expect {
          post "/api/transactions/",
               params: { transaction: valid_attributes }, as: :json
        }.to change(Transaction, :count).by(1)
      end

      it "renders a JSON response with the new transaction" do
        post "/api/transactions/",
             params: { transaction: valid_attributes }, as: :json

        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it "validate correct values" do
        post "/api/transactions/",
          params: { transaction: valid_attributes }, as: :json

        expect(response_body["from_currency"]).to eq(valid_attributes[:from_currency])
        expect(response_body["from_value"]).to eq(valid_attributes[:from_value])
        expect(response_body["rate"]).to eq(value / valid_attributes[:from_value])
        expect(response_body["to_currency"]).to eq(valid_attributes[:to_currency])
        expect(response_body["to_value"]).to eq(value)
        expect(response_body["user_id"]).to eq(valid_attributes[:user_id])
      end
    end

    context "with invalid parameters" do
      it "does not create a new transaction" do
        expect {
          post "/api/transactions/",
               params: { transaction: invalid_attributes }, as: :json
        }.to change(Transaction, :count).by(0)
      end

      it "renders a JSON response with errors for the new test" do
        post "/api/transactions/",
             params: { transaction: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")
      end
    end
  end

  # PUT /users/:user_id
  context "PUT /update" do
    let(:user) { create(:user) }
    let(:transaction) { create(:transaction) }
    let(:valid_attributes) do
      attributes_for(:transaction, user_id: user.id)
    end

    let(:invalid_attributes) do
      attributes_for(:transaction, user_id: 9999999)
    end

    let(:value){ 3.67306 }

    let(:currency_api_response) do
      {
        "meta": {
          "last_updated_at": "2023-06-23T10:15:59Z"
        },
        "data": {
          "AED": {
            "code": "EUR",
            "value": value
          }
        }
      }
    end

    before(:each) do
      allow(HTTParty).to receive(:get).and_return(currency_api_response)
      allow_any_instance_of(TransactionManagment::UpdateService).to receive(:get_values_from_currency_api).and_return(value)
    end

    context "with valid parameters" do
      it "updates the requested" do
        put "/api/transactions/#{transaction.user_id}",
              params: { transaction: valid_attributes }, as: :json

        expect(response).to have_http_status(:created)
        expect(response_body["from_currency"]).to eq(valid_attributes[:from_currency])
        expect(response_body["from_value"]).to eq(valid_attributes[:from_value])
        expect(response_body["to_currency"]).to eq(valid_attributes[:to_currency])
        expect(response_body["user_id"]).to eq(valid_attributes[:user_id])
        expect(response_body["to_value"]).to eq(value)
        expect(response_body["rate"]).to eq(value / valid_attributes[:from_value])
      end

      it "renders a JSON response" do
        put "/api/transactions/#{transaction.user_id}",
              params: { transaction: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors" do
        put "/api/transactions/#{transaction.user_id}",
              params: { transaction: invalid_attributes }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")
      end
    end
  end

  # DELETE /users/:user_id
  context "DELETE /destroy" do
    let(:transaction){ create(:transaction)}
    it "destroys the requested" do
      expect {
        delete "/api/transactions/#{transaction.user_id }", as: :json
      }.to change(Transaction, :count).by(0)
    end
  end
end
