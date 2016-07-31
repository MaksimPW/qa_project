class Answer < ActiveRecord::Base
  include UserVotable

  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable

  validates :user_id, presence: true
  validates :question_id, presence: true

  validates :body, presence: true,
                   length: { minimum: 30 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :order_best_first, -> { order('best DESC NULLS LAST') }

  def is_best!
    transaction do
      self.question.answers.where(best: true).update_all(best: false)
      update! best: true
    end
  end
end
