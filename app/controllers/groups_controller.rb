class GroupsController < ApplicationController
  def create
    @group = Group.new(group_params)
    if @group.save
      # グループ作成成功
      @current_user.update(group_id: @group.id)
      # 成功した旨のレスポンスを返す
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def group_params
    params.require(:group).permit(:name, :password)
  end
end
