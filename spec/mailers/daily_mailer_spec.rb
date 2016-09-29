require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let!(:questions) { create_list :question, 2, user: user, created_at: (Time.now - 20.hours) }
    let(:titles) { questions.map(&:title) }
    let(:mail) { DailyMailer.digest(user, titles) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Daily digest questions')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('DailyMailer#digest')
    end
  end
end
