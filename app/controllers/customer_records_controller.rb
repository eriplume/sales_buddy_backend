class CustomerRecordsController < ApplicationController
  def index
    user_id = @current_user.id
    render json: CustomerRecord.summary_by_user(user_id)
  end
end
