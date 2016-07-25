require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many :attachments}

  it { should validate_presence_of :user_id }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(30) }

  it { should accept_nested_attributes_for :attachments }

  describe 'is_best!' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:best_answer) { create(:answer, best: true, question: question) }

    it { expect { answer.is_best! }.to change(answer, :best).to(true) }

    it 'change best answer for one question' do
      answer.is_best!
      best_answer.reload
      expect(best_answer).to_not be_best
    end
  end
end
