module CrudManagment
  class ShowService < CrudManagment::BaseService
    attr_accessor :klass, :params
    def initialize(klass, params)
      @klass = super(klass)
      @params = params
    end

    def call
      load_object
      klass
    end

    def render_json
      super
    end

    def status_code
      super
      return 200
    end

    private
    def load_object
      @klass = klass.find_by(@params)
    end
  end
end