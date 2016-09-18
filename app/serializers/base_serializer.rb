class BaseSerializer < ActiveModel::Serializer
  def attachments_url
    object.attachments.map do |a|
      a.file.url
    end
  end
end