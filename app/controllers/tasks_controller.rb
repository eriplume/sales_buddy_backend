class TasksController < ApplicationController
  before_action :set_task, only: %i[update destroy complete]

  def index
    user_id = @current_user.id
    group_id = @current_user.group_id

    user_tasks = Task.where(user_id:).includes(:user).order(:deadline)
    group_tasks = Task.where(group_id:).includes(:user).order(:deadline)
    render json: {
      user_tasks: transform_tasks(user_tasks),
      group_tasks: transform_tasks(group_tasks)
    }
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      TaskNotificationService.new(@task).call if @task.is_group_task
      render json: { status: 'success' }
    else
      logger.debug @task.errors.full_messages
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def complete
    user_id = @current_user.id
    if @task.update(is_completed: true, completed_by_id: user_id)
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :is_group_task, :importance, :deadline, :user_id, :group_id)
  end

  def transform_tasks(tasks)
    tasks.map do |task|
      task.as_json(
        only: %i[id title is_group_task importance deadline user_id group_id is_completed],
        methods: %i[user_name user_image_url completed_by_name]
      ).transform_keys { |key| key.to_s.camelize(:lower) }
    end
  end
end
