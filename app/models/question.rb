class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, presence: true,
                    length: { minimum: 15 }

  validates :body, presence: true,
                   length: { minimum: 30 }
end
