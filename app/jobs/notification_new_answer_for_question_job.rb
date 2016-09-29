class NotificationNewAnswerForQuestionJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    NotificationMailer.new_answer_for_question(answer).deliver_later
  end
end
