module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[update destroy]

    def index
      users = User.order(:id)
      render json: { users: transform_users(users) }
    end

    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy!
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:role)
    end

    def transform_users(users)
      users.map do |user|
        user.as_custom_json.transform_keys { |key| key.to_s.camelize(:lower) }
      end
    end
  end
end
