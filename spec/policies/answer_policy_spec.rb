require 'rails_helper'

RSpec.describe AnswerPolicy do

  let(:user) { create(:user) }
  let(:guest) { nil }
  let(:quser) { create(:user) }
  let(:user_question) { create(:question, user: quser) }
  let(:user_answer) { create(:answer, user: user, question: user_question) }
  let(:answer) { Answer }

  subject { described_class }

  permissions :create? do
    it 'grants access if authenticated user' do
      expect(subject).to permit(user, answer)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(guest, answer)
    end
  end

  permissions :update? do
    it 'grants access if user is author' do
      expect(subject).to permit(user, user_answer)
    end

    it 'denies access if authenticated user' do
      expect(subject).not_to permit(User.new, user_answer)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, user_answer)
    end
  end

  permissions :best? do
    it 'grants access if user is author of question' do
      expect(subject).to permit(quser, user_answer)
    end

    it 'denies access if user is author of answer and question' do
      expect(subject).not_to permit(quser, create(:answer, question: user_question, user: quser))
    end

    it 'denies access if authenticated user' do
      expect(subject).not_to permit(User.new, user_answer)
    end

    it 'denies access if user is author of answer' do
      expect(subject).not_to permit(user, user_answer)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, user_answer)
    end
  end

  permissions :destroy? do
    it 'grants access if user is author' do
      expect(subject).to permit(user, user_answer)
    end

    it 'denies access if authenticated user' do
      expect(subject).not_to permit(User.new, user_answer)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, user_answer)
    end
  end
end