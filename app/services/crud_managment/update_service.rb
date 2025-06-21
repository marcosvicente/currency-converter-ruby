# frozen_string_literal: true

module CrudManagment
  class UpdateService < CrudManagment::BaseService
    attr_accessor :klass, :params, :item_params
    def initialize(klass, params, item_params)
      @klass = super(klass)
      @params = params
      @item_params = item_params
      @status_cod = nil
    end

    def call
      update
      klass
    end

    def render_json
      super
    end

    def status_code
      super()
      @status_code
    end

    def update
      @klass = load_object
      if @klass.update(set_params)
        @status_code = 201
        @klass
      else
        @status_code = 422
        @klass.errors.full_messages
        Rails.logger.error "Error Update: #{@klass.errors.full_messages}"
      end
    end

    def set_params
      @params
    end

    def load_object
      @klass.find_by(@item_params)
    end
  end
end
