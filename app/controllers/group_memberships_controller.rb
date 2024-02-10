class GroupMembershipsController < ApplicationController
  def join
    group = Group.find_by(name: group_params[:name])
    if group&.authenticate(group_params[:password])
      @current_user.update(group_id: group.id)
      render json: { status: 'success' }
    else
      render json: { error: 'キーワードが間違っています' }, status: :unprocessable_entity
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :password)
  end
end
