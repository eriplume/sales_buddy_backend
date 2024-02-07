class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy]

  def create
    comment = @current_user.comments.build(comment_params)
    if comment.save
      render json: { status: 'success' }
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy!
  end
    
  private
    
  def comment_params
    params.require(:comment).permit(:content).merge(task_id: params[:task_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
