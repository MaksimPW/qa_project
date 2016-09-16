class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :attachments_url, :question_id, :user_id, :best, :score
  has_many :comments

  def attachments_url
    object.attachments.map do |a|
      a.file.url
    end
  end
end
