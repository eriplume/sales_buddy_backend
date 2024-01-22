class GroupsController < ApplicationController
  def create
    @group = Group.new(group_params)
    if @group.save
      @current_user.update(group_id: @group.id)
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def group_params
    params.require(:group).permit(:name, :password)
  end
end
