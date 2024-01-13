class WeeklyTargetsController < ApplicationController
  def index
    user_id = @current_user.id
    @weekly_targets = WeeklyTarget.where(user_id:)
    render json: @weekly_targets.as_json(only: %i[target start_date end_date])
  end

  def create
    @weekly_target = WeeklyTarget.new(target_params)
    if @weekly_target.save
      render json: { status: 'success' }
    else
      render json: @weekly_target.errors, status: :unprocessable_entity
    end
  end

  private

  def target_params
    params.require(:weekly_target).permit(:target, :start_date, :end_date, :user_id)
  end
end
