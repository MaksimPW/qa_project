class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user, titles)
    @titles = titles
    mail to: user.email, subject: 'Daily digest questions'
  end
end