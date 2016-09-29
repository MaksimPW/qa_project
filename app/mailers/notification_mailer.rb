class NotificationMailer < ApplicationMailer
  def new_answer_for_question(answer)
    @answer = answer
    @question = Question.find_by_id(@answer.question_id)
    @user = @question.user

    mail to: @user.email, subject: 'Notification'
  end
end
