require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users) { create_list :user, 2 }

  context 'fresh questions exist' do
    let!(:questions) { create_list :question, 2, user: users.first, created_at: (Time.now - 20.hours) }
    let(:titles) { questions.map(&:title) }

    it 'sends daily digest to all users' do
      users.each do |user|
        expect(DailyMailer).to receive(:digest).with(user, titles).and_call_original
      end
      described_class.perform_now
    end
  end

  context 'there are no fresh quesitons' do
    it 'does not send daily digest' do
      expect(DailyMailer).not_to receive(:digest)
      described_class.perform_now
    end
  end
end