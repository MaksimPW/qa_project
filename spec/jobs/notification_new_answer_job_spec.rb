require 'rails_helper'

RSpec.describe NotificationNewAnswerJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  context 'before create new answer' do
    let(:answer) { create(:answer, question: question) }

    it 'should send notification question mailer' do
      expect(NotificationMailer).to receive(:new_answer_for_question).with(answer, user).and_call_original

      described_class.perform_now(answer)
    end
  end
end
