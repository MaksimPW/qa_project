RSpec.shared_examples_for 'user_commentable' do
  it { should have_many(:comments).dependent(:destroy) }
end