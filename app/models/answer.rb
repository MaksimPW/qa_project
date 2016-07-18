class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user_id, presence: true
  validates :question_id, presence: true

  validates :body, presence: true,
                   length: { minimum: 30 }

  def is_best!
    transaction do
      self.question.answers.where(best: true).update_all(best: false)
      update! best: true
    end
  end
end
