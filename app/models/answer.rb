class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  validates :question_id, presence: true

  validates :body, presence: true,
                   length: { minimum: 30 }
end
