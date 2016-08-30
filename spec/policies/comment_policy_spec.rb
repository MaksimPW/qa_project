require 'rails_helper'

RSpec.describe CommentPolicy do

  let(:user) { create(:user) }
  let(:comment) { create(:comment, commentable: create(:answer)) }
  let(:user_comment) { create(:comment, user: user, commentable: create(:answer)) }
  let(:guest) { nil }

  subject { described_class }

  permissions :show? do
    it 'grants access if authenticated user' do
      expect(subject).to permit(user, comment)
    end

    it 'grants access if user is guest' do
      expect(subject).to permit(guest, comment)
    end
  end

  permissions :create? do
    it 'grants access if authenticated user' do
      expect(subject).to permit(user, comment)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, comment)
    end
  end

  permissions :destroy? do
    it 'grants access if user is author' do
      expect(subject).to permit(user, user_comment)
    end

    it 'denies access if authenticated user' do
      expect(subject).not_to permit(User.new, user_comment)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, user_comment)
    end
  end
end
