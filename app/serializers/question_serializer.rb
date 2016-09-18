class QuestionSerializer < BaseSerializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :attachments_url, :user_id
  has_many :answers
  has_many :comments

  def short_title
    object.title.truncate(10)
  end
end
