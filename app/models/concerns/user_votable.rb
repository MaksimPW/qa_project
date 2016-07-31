module UserVotable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def create_vote(user, value)
    ActiveRecord::Base.transaction do
      vote = votes.find_or_initialize_by(user: user)
      vote.update_attribute :value, value
      update_score
    end
  end

  def destroy_vote(user)
    ActiveRecord::Base.transaction do
      vote = votes.find_by(user: user)
      if vote
        vote.destroy
        update_score
      end
    end
  end

  private

  def update_score
    update_attribute :score, votes.sum(:value)
  end
end