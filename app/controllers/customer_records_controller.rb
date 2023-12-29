class CustomerRecordsController < ApplicationController
  def index
    user_id = request.headers['user']
    render json: CustomerRecord.summary_by_user(user_id)
  end
end
