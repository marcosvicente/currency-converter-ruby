# == Schema Information
#
# Table name: transactions
#
#  id            :integer          not null, primary key
#  from_currency :string
#  from_value    :integer
#  rate          :float
#  to_currency   :string
#  to_value      :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
# Indexes
#
#  index_transactions_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Transaction < ApplicationRecord
  belongs_to :user

  validates :from_currency, presence: true
  validates :from_value, presence: true
  validates :rate, presence: true
  validates :to_currency, presence: true
  validates :to_value, presence: true
end
