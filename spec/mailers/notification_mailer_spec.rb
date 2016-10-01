require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe 'new_answer_for_question' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:answer) { build(:answer, question: question) }
    let(:mail) { NotificationMailer.new_answer_for_question(answer, user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notification')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('NotificationMailer#new_answer_for_question')
    end
  end
end
