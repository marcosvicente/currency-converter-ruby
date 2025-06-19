# frozen_string_literal: true

require 'rails_helper'

module ApiHelper
  def response_body
    JSON.parse(response.body).deep_symbolize_keys
  end
end
