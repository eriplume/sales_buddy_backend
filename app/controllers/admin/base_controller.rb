class Admin::BaseController < ApplicationController
  before_action :check_admin

  private

  def check_admin
    render json: { error: 'Unauthorized' }, status: :forbidden unless @current_user.admin?
  end
end
