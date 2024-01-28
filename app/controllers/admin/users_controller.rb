class Admin::UsersController < Admin::BaseController
  def index
    users = User.all
    render json: { users: transform_users(users) }
  end

  private

  def transform_users(users)
    users.map do |user|
      user.as_json(
        only: %i[id name group_id role]
      ).transform_keys { |key| key.to_s.camelize(:lower) }
    end
  end
end
