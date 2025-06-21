class TransactionSerializer < ActiveModel::Serializer
  attributes :transaction_id
  attributes :from_currency
  attributes :from_value
  attributes :rate
  attributes :to_currency
  attributes :to_value
  attributes :timestamps
  attributes :user_id

  def transaction_id
    object.id
  end

  def timestamps
    object.created_at
  end
end
