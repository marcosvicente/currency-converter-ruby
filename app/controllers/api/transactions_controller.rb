class Api::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy]

  # GET /transactions
  def index
    transactions = CrudManagment::IndexService.new(
      Transaction,
      nil,
      paginate_params,
      "created_at"
    ).render_json

    render json: transactions[:data], status: transactions[:status_code]
  end

  # GET /transactions/{user_id}
  def show
    transaction = CrudManagment::ShowService.new(
      Transaction,
      get_user_id_params
    ).render_json

    render json: transaction[:data], status: transaction[:status_code]
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      render json: @transaction, status: :created
    else
      render json: { errors: @transaction.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /transactions/{user_id}
  def update
    if @transaction.update(transaction_params)
        render json: @transaction, status: :created
    else
      render json: { errors: @transaction.errors.full_messages },
        status: :unprocessable_entity
    end
  end

  # DELETE /transactions/{username}
  def destroy
    @transaction.destroy
  end

  private
  def get_user_id_params
    { user_id: params[:user_id] }
  end
  def set_transaction
    @transaction = Transaction.find(params[:user_id])
  end

  def transaction_params
    params.require(:transaction).permit(
      :from_currency,
      :from_value,
      :rate,
      :to_currency,
      :to_value,
      :user_id
    )
  end

  def paginate_params
    params.permit(
      :page, :per_page
    )
  end
end
