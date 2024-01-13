class UsersController < ApplicationController
  require 'jwt'

  before_action :verify_api_token, only: [:authenticate]
  skip_before_action :authenticate_user, only: [:authenticate]

  def authenticate
    user = authenticate_line_user
    if user.save
      # JWTトークンを生成
      token = encode_jwt(user.id)
      # トークンを返す
      render json: { status: 'success', user: { token:, user_id: user.id } }
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

  def authenticate_line_user
    User.authenticate_with_line_id(user_params[:line_id], user_params[:name])
  end

  def verify_api_token
    api_token = request.headers['Authorization']&.split(' ')&.last
    head :unauthorized unless api_token && ActiveSupport::SecurityUtils.secure_compare(api_token,
                                                                                       ENV.fetch('API_TOKEN', nil))
  end

  def encode_jwt(user_id)
    payload = { user_id: }
    JWT.encode(payload, ENV.fetch('SECRET_KEY_BASE', nil))
  end
end
