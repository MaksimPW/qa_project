class Answer < ActiveRecord::Base
  validates :body, presence: true
  validates :body, length: { minimum: 30 }
end
