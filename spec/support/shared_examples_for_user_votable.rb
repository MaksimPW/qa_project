RSpec.shared_examples_for 'user_votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:object) { create(:answer) }
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    object.create_vote(user, 1)
  end
  describe 'create_vote' do
    it 'create vote' do
      expect(object.votes.count).to eq(1)
    end

    it 'count score for object' do
      object.create_vote(user1, 1)
      object.create_vote(user2, -1)
      expect(object.score).to eq(1)
    end

    it 'create vote can only once' do
      object.create_vote(user, 1)
      expect(object.score).to eq(1)
    end
  end

  describe 'destroy_vote' do
    before do
      object.destroy_vote(user)
    end

    it 'destroy vote' do
      expect(object.votes.count).to eq(0)
    end

    it 'count score for object' do
      expect(object.score).to eq(0)
    end
  end

  describe 'voted?' do
    it 'return boolean' do
      expect(user.voted?(object)).to be_truthy
    end
  end
end