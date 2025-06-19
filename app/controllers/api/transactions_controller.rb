class Api::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy]

  # GET /transactions
  def index
    @transactions = Transaction.order(:created_at).page(paginate_params[:page]).per(paginate_params[:per_page])
    
    render json: @transactions, status: :ok
  end

  # GET /transactions/{user_id}
  def show
    render json: @transaction, status: :ok
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
