class AnswerSerializer < BaseSerializer
  attributes :id, :body, :created_at, :updated_at, :attachments_url, :question_id, :user_id, :best, :score
  has_many :comments
end
