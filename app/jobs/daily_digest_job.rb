class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    @titles = Question.daily.map(&:title)
    if @titles.present?
      User.find_each do |user|
        DailyMailer.digest(user, @titles).deliver_later
      end
    end
  end
end
