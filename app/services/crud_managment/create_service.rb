# frozen_string_literal: true

module CrudManagment
  class CreateService < CrudManagment::BaseService
    attr_accessor :klass, :params
    def initialize(klass, params)
      @klass = super(klass)
      @params = params
      @status_code = nil
    end

    def call
      create
      klass
    end

    def render_json
      super
    end

    def status_code
      super()
      @status_code
    end

    def create
      instance_klass = load_object
      if instance_klass.save
        @status_code = 201
        Rails.logger.info "Create endpoint to #{klass.to_s} accessed"
        instance_klass
      else
        Rails.logger.error "Error Create: #{@klass.errors.full_messages}"
        @status_code = 422
        instance_klass.errors.full_messages
      end
    end

    private

    def load_object
      @klass = @klass.new(params)
    end
  end
end
