class CustomerTypesController < ApplicationController
  def index
    customer_types = CustomerType.order(:id)
    options = customer_types.map do |type|
      { value: type.id, label: type.name }
    end
    render json: options
  end
end
