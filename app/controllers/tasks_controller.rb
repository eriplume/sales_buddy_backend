class TasksController < ApplicationController
  def index
    user_id = @current_user.id
    group_id = @current_user.group_id
    
    user_tasks = Task.where(user_id:).includes(:user).order(:deadline)
    group_tasks = Task.where(group_id:).includes(:user).order(:deadline)
    render json: {
      user_tasks: user_tasks.map { |task| 
        task.as_json(only: %i[id title is_group_task importance deadline user_id group_id],methods: :user_name)
          .transform_keys { |key| key.to_s.camelize(:lower) }
      },
      group_tasks: group_tasks.map { |task| 
        task.as_json(only: %i[id title is_group_task importance deadline user_id group_id],methods: :user_name)
          .transform_keys { |key| key.to_s.camelize(:lower) }
      }
    }
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      render json: { status: 'success' }
    else
      logger.debug @task.errors.full_messages
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :is_group_task, :importance, :deadline, :user_id, :group_id)
  end
end
