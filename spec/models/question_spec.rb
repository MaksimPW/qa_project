require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many :attachments }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should validate_length_of(:title).is_at_least(15) }
  it { should validate_length_of(:body).is_at_least(30) }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'user_votable'
  it_behaves_like 'user_commentable'

  let(:users) { create_list(:user, 2) }

  describe '#subscribe!' do
    let!(:question) { create(:question) }
    let(:do_request){ question.subscribe!(users.last) }
    let(:model){ Subscription }
    let(:subject) { build(:question, user: users.first ) }

    it_behaves_like 'Changeable table size', 1

    it 'user subscribe' do
      do_request
      expect(question.subscriptions.last.user).to eq users.last
    end

    it 'should receive after create' do
      expect(subject).to receive(:subscribe!).with(users.first)
      subject.save!
    end
  end

  describe '#subscribed?' do
    let!(:question) { create(:question) }
    let!(:subscribe) { create(:subscription, user: users.first, question: question) }

    it 'user subscribed' do
      expect(question.subscribed?(users.first)).to be_truthy
    end

    it 'user does not subscribed' do
      expect(question.subscribed?(users.last)).to be_falsey
    end
  end
end
