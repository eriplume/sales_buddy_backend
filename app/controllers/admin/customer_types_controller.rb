module Admin
  class CustomerTypesController < BaseController
    before_action :set_type, only: %i[update destroy]

    def index
      customer_types = CustomerType.order(:id)
      render json: { customer_types: transform_customer_types(customer_types) }
    end

    def create
      @customer_type = CustomerType.new(customer_type_params)
      if @customer_type.save
        render json: { status: 'success' }
      else
        render json: @customer_type.errors, status: :unprocessable_entity
      end
    end

    def update
      if @customer_type.update(customer_type_params)
        render json: @customer_type
      else
        render json: @customer_type.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @customer_type.destroy!
    end

    private

    def set_type
      @customer_type = CustomerType.find(params[:id])
    end

    def customer_type_params
      params.require(:customer_type).permit(:name)
    end

    def transform_customer_types(customer_types)
      customer_types.map do |type|
        type.as_json.transform_keys { |key| key.to_s.camelize(:lower) }
      end
    end
  end
end
