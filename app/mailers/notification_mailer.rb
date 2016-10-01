class NotificationMailer < ApplicationMailer
  def new_answer_for_question(answer, user)
    @answer = answer
    @question = Question.find(@answer.question_id)
    @user = user

    mail to: @user.email, subject: 'Notification'
  end
end
