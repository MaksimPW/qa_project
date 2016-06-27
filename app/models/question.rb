class Question < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true

  validates :title, length: { minimum: 15 }
  validates :body, length: { minimum: 30 }
end
