class UsersController < ApplicationController
  before_action :verify_api_token, only: [:authenticate]

  def authenticate
    user = User.authenticate_with_line_id(user_params[:line_id], user_params[:name])

    if user.save
      render json: { status: 'success', user: { id: user.id } }
    else
      Rails.logger.info "User validation failed: #{user.errors.full_messages}"
      render json: { status: 'error', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(params[:id])
    if user
      render json: { notifications: user.notifications }
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update_notifications
    user = User.find(params[:id])
    if user.update(notifications: user_notifications_params[:notifications])
      render json: { success: true }
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:line_id, :name)
  end

  def user_notifications_params
    params.require(:user).permit(:notifications)
  end

  def verify_api_token
    api_token = request.headers['Authorization']&.split(' ')&.last
    head :unauthorized unless api_token && ActiveSupport::SecurityUtils.secure_compare(api_token,
                                                                                       ENV.fetch('API_TOKEN', nil))
  end
end
