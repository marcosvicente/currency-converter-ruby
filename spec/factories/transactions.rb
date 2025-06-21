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
FactoryBot.define do
  factory :transaction do
    user { create(:user) }
    from_currency { CurrencyEnumeration::USD  }
    to_currency { CurrencyEnumeration::BRL  }
    from_value { Faker::Number.number(digits: 2) }
    to_value { Faker::Number.decimal(l_digits: 2)  }
    rate { Faker::Number.decimal(l_digits: 2) }
  end
end
