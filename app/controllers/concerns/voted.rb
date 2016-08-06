module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_vote, only: [:vote_up,
                                     :vote_down,
                                     :vote_destroy]
  end

  def vote_up
    set_vote(1, 'up')
  end

  def vote_down
    set_vote(-1, 'down')
  end

  def vote_destroy
    if current_user.voted?(@votable_object)
      @votable_object.destroy_vote(current_user)
      render json: { object: @votable_object.id,
                     score: @votable_object.score,
                     button_vote: 'destroy',
                     kontroller: "#{controller_name.singularize}"
             }
    else
      render json: { errors: 'Not found' }, status: :not_found
    end
  end

  private

  def load_vote
    @votable_object = controller_name.singularize.classify.constantize.find(params[:id])
  end

  def set_vote(value, button_vote)
    if current_user.author_of?(@votable_object)
      render json: { errors: 'You can`t vote own record' }, status: :forbidden
    else
      @votable_object.create_vote(current_user, value)
      render json: { object: @votable_object.id,
                     score: @votable_object.score,
                     button_vote: button_vote,
                     kontroller: "#{controller_name.singularize}"
             }
    end
  end
end