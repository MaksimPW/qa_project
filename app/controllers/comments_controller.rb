class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  before_action :load_comment, only: :destroy
  after_action :publish_pub, only: [:create, :destroy]

  respond_to :json

  def create
    @comment = @commentable_object.comments.create(body: comment_params[:body], user: current_user)
    respond_with @comment
  end

  def destroy
    if current_user.author_of? @comment
      respond_with(@comment.destroy!)
    else
      render json: { id: @comment.id }, status: :forbidden
    end
  end

  private

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def load_commentable
    id = params.keys.detect { |k| k.to_s =~ /(question|answer)_id/ }
    @commentable_object = $1.classify.constantize.find(params[id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_pub
    PrivatePub.publish_to '/comments', comment: @comment, method: self.action_name
  end
end
