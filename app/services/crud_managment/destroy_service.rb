# frozen_string_literal: true

module CrudManagment
  class DestroyService < CrudManagment::BaseService
    attr_accessor :klass, :params
    def initialize(klass, params)
      @klass = super(klass)
      @params = params
      @status_cod = nil
    end

    def call
      delete
      klass
    end

    def render_json
      super
    end

    def status_code
      super()
      @status_code
    end

    def delete
      instance_klass = load_object
      unless instance_klass.nil?
        instance_klass.destroy
        @status_code = 201
        instance_klass
      else
        @status_code = 422
      end
    end

    private

    def load_object
      @klass = klass.find_by(@params)
    end
  end
end
