class Question < ActiveRecord::Base
  include UserVotable
  include UserCommentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :attachments, as: :attachable

  validates :user_id, presence: true

  validates :title, presence: true,
                    length: { minimum: 15 }

  validates :body, presence: true,
                   length: { minimum: 30 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :daily, -> { where('created_at > ?', 1.day.ago) }

  after_create do
    subscribe!(self.user)
  end

  def subscribed?(current_user)
    self.subscriptions.exists?(user: current_user)
  end

  def subscribe!(current_user)
    self.subscriptions.create(user: current_user) unless subscribed?(current_user)
  end
end
