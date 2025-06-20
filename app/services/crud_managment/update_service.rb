# frozen_string_literal: true

module CrudManagment
  class UpdateService < CrudManagment::BaseService
    attr_accessor :klass, :params
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
      instance_klass = load_object
      if instance_klass.update(@params)
        @status_code = 201
        instance_klass
      else
        instance_klass.errors.full_messages
        @status_code = 422
      end
    end

    private

    def load_object
      @klass = klass.find_by(@item_params)
    end
  end
end
