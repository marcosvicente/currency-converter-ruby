module CrudManagment
  class IndexService < CrudManagment::BaseService
    attr_accessor :klass, :params, :paginate_params, :order

    def initialize(klass, params, paginate_params, order)
      @klass = super(klass)
      @params = params
      @paginate_params = paginate_params
      @order = order
    end

    def call
      get_params
      paginate
      order
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
    def paginate
      unless paginate_params.nil?
        @klass = @klass.page(@paginate_params[:page]).per(@paginate_params[:per_page])
      end
    end

    def order
      unless @order.nil?
        @klass = @klass.order(@order)
      end
    end

    def get_params
      unless @params.nil?
        @klass = @klass.where(@params)
      else
        @klass = @klass.all
      end
    end
  end
end