class NotificationNewAnswerJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.each do |subscribe|
      NotificationMailer.new_answer_for_question(answer, subscribe.user).deliver_later
    end
  end
end
