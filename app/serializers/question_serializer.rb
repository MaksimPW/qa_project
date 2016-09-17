class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :attachments_url, :user_id
  has_many :answers
  has_many :comments

  def short_title
    object.title.truncate(10)
  end

  def attachments_url
    object.attachments.map do |a|
      a.file.url
    end
  end
end
