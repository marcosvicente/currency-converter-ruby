class Api::TransactionsController < ApplicationController
  # GET /api/transactions
  def index
    transactions = CrudManagment::IndexService.new(
      Transaction,
      nil,
      paginate_params,
      "created_at"
    ).render_json

    render json: transactions[:data], status: transactions[:status_code]
  end

  # GET /api/transactions/{user_id}
  def show
    transaction = CrudManagment::ShowService.new(
      Transaction,
      get_user_id_params
    ).render_json

    render json: transaction[:data], status: transaction[:status_code]
  end

  # POST /api/transactions
  def create
    transaction = TransactionManagment::CreateService.new(
      Transaction,
      transaction_params
    ).render_json

    render json: transaction[:data], status: transaction[:status_code]
  end

  # PUT /api/transactions/{user_id}
  def update
    transaction = TransactionManagment::UpdateService.new(
      Transaction,
      transaction_params,
      get_user_id_params
    ).render_json

    render json: transaction[:data], status: transaction[:status_code]
  end

  # DELETE /api/transactions/{username}
  def destroy
    transaction = CrudManagment::DestroyService.new(
      Transaction,
      get_user_id_params
    ).render_json

    render json: transaction[:data], status: transaction[:status_code]
  end

  private
  def get_user_id_params
    { user_id: params[:user_id] }
  end

  def transaction_params
    params.require(:transaction).permit(
      :from_currency,
      :from_value,
      :to_currency,
      :user_id
    )
  end

  def paginate_params
    params.permit(
      :page, :per_page
    )
  end
end
