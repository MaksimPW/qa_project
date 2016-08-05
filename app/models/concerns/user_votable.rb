module UserVotable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def create_vote(user, value)
    ActiveRecord::Base.transaction do
      vote = votes.find_or_initialize_by(user: user)
      update_score if vote.update!(value: value)
    end
  end

  def destroy_vote(user)
    ActiveRecord::Base.transaction do
      vote = votes.find_by(user: user)
      update_score if vote.destroy!
    end
  end

  private

  def update_score
    update!(score: votes.sum(:value))
  end
end