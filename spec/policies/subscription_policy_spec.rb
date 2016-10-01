require 'rails_helper'

RSpec.describe SubscriptionPolicy do

  let(:user) { create(:user) }
  let(:guest) { nil }

  let(:subscription) { create(:subscription) }
  let(:user_subscription) { create(:question, user: user) }

  subject { described_class }

  permissions :create? do
    it 'grants access if authenticated user' do
      expect(subject).to permit(user, subscription)
    end

    it 'grants access if user is guest' do
      expect(subject).to_not permit(guest, subscription)
    end
  end

  permissions :destroy? do
    it 'grants access if user is author' do
      expect(subject).to permit(user, user_subscription)
    end

    it 'denies access if authenticated user' do
      expect(subject).not_to permit(User.new, user_subscription)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, user_subscription)
    end
  end
end