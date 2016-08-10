class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create

  def create
    @comment = @commentable_object.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: { comment: @comment }
      PrivatePub.publish_to '/comments', comment: @comment, method: 'create'
    else
      render json: { errors: @comment.errors.full_messages.as_json }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy!
      render json: { id: @comment.id }
      PrivatePub.publish_to '/comments', id: @comment.id, method: 'destroy'
    end
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Not found' }, status: :unprocessable_entity
  end

  private

  def load_commentable
    @commentable_object =
      if params.keys.include? 'answer_id'
        Answer.find(params[:answer_id])
      else
        Question.find(params[:question_id])
      end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
