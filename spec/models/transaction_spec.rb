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

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject(:transaction) { build(:transaction) }

  it { is_expected.to validate_presence_of(:from_currency) }
  it { is_expected.to validate_presence_of(:from_value) }
  it { is_expected.to validate_presence_of(:rate) }
  it { is_expected.to validate_presence_of(:to_currency) }
  it { is_expected.to validate_presence_of(:to_value) }
end
