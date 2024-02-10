class GroupsController < ApplicationController
  before_action :set_group, only: %i[index]

  def index
    members = @group.users.select(:id, :name, :image_url)
    render json: { members: transform_members(members) }
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      @current_user.update(group_id: @group.id)
    else
      render json: { error: @group.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { error: 'グループ名がすでに使用されています' }, status: :unprocessable_entity
  end

  private

  def group_params
    params.require(:group).permit(:name, :password)
  end

  def set_group
    group_id = @current_user.group_id
    @group = Group.find(group_id)
  end

  def transform_members(members)
    members.map do |member|
      member.as_json.transform_keys { |key| key.to_s.camelize(:lower) }
    end
  end
end
