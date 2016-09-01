require 'rails_helper'

RSpec.describe QuestionPolicy do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:user_question) { create(:question, user: user) }
  let(:guest) { nil }

  subject { described_class }

  permissions :index? do
    it 'grants access if authenticated user' do
      expect(subject).to permit(user, question)
    end

    it 'grants access if user is guest' do
      expect(subject).to permit(guest, question)
    end
  end

  permissions :show? do
    it 'grants access if authenticated user' do
      expect(subject).to permit(user, question)
    end

    it 'grants access if user is guest' do
      expect(subject).to permit(guest, question)
    end
  end

  permissions :new? do
    it 'grants access if authenticated user' do
      expect(subject).to permit(user, question)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, question)
    end
  end

  permissions :create? do
    it 'grants access if authenticated user' do
      expect(subject).to permit(user, question)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, question)
    end
  end

  permissions :update? do
    it 'grants access if user is author' do
      expect(subject).to permit(user, user_question)
    end

    it 'denies access if authenticated user' do
      expect(subject).not_to permit(User.new, user_question)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, user_question)
    end
  end

  permissions :destroy? do
    it 'grants access if user is author' do
      expect(subject).to permit(user, user_question)
    end

    it 'denies access if authenticated user' do
      expect(subject).not_to permit(User.new, user_question)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, user_question)
    end
  end
end
