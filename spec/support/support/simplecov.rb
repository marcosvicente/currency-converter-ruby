# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/bin'
  add_filter '/db'
  add_filter '/spec'

  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Polices', 'app/polices'
  add_group 'Serializers', 'app/serializable'
end
