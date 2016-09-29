# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def new_answer_for_question
    NotificationMailer.new_answer_for_question(@answer)
  end
end
