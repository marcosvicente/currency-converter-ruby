module CrudManagment
  class BaseService
    include ActiveModel::Model
    def initialize(klass)
      @klass = klass
    end

    def call
    end

    def render_json
      call
      if @klass.nil?
        { data: "Not have data", status_code: 404 }
      else
        { data: @klass, status_code: status_code }
      end
    end

    def status_code
    end
  end
end
