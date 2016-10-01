class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    @titles = Question.daily.pluck(:title)
    unless @titles.empty?
      User.find_each do |user|
        DailyMailer.digest(user, @titles).deliver_later
      end
    end
  end
end
