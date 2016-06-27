class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true,
                   length: { minimum: 30 }
end
