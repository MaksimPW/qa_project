require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  sign_in_user
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  let(:comment) { create(:comment, user: @user) }
  let(:invalid_comment) { create(:invalid_comment) }

  describe 'POST #create' do
    context 'question' do
      let(:do_request) { post :create, question_id: question, comment: attributes_for(:comment), format: :json }

      it 'assigns to @question' do
        do_request
        expect(assigns(:commentable_object)).to eq question
      end

      let(:model) { question.comments }
      it_behaves_like 'Changeable table size', 1

      let(:model) { @user.comments }
      it_behaves_like 'Changeable table size', 1
      it_behaves_like 'Renderable json true'
      it_behaves_like 'Able PrivatePub'
    end

    context 'answer' do
      let(:do_request) { post :create, answer_id: answer, comment: attributes_for(:comment), format: :json }

      it 'assigns to @answer' do
        do_request
        expect(assigns(:commentable_object)).to eq answer
      end

      let(:model) { answer.comments }
      it_behaves_like 'Changeable table size', 1

      let(:model) { @user.comments }
      it_behaves_like 'Changeable table size', 1
      it_behaves_like 'Renderable json true'
      it_behaves_like 'Able PrivatePub'
    end
  end

  describe 'DELETE #destroy' do
    context 'question' do
      let!(:question_comment) { create(:comment, user: @user, commentable: question) }
      let!(:other_comment) { create(:comment, commentable: question) }
      let(:do_request) { delete :destroy, id: question_comment, format: :json }

      it_behaves_like 'Renderable json empty'

      let(:model) { @user.comments }
      it_behaves_like 'Changeable table size', -1

      let(:model) { question.comments }
      it_behaves_like 'Changeable table size', -1
      it_behaves_like 'Able PrivatePub'

      context 'other comment' do
        let(:do_request) { delete :destroy, id: other_comment, format: :json }
        let(:model) { Comment }
        it_behaves_like 'Does not changeable table size'
        it_behaves_like 'Renderable alert flash message'
        it_behaves_like 'Disable PrivatePub'
      end

    end

    context 'answer' do
      let!(:answer_comment) { create(:comment, user: @user, commentable: answer) }
      let!(:other_comment) { create(:comment, commentable: answer) }
      let(:do_request) { delete :destroy, id: answer_comment, format: :json }

      it_behaves_like 'Renderable json empty'

      let(:model) { @user.comments }
      it_behaves_like 'Changeable table size', -1

      let(:model) { answer.comments }
      it_behaves_like 'Changeable table size', -1
      it_behaves_like 'Able PrivatePub'

      context 'other comment' do
        let(:do_request) { delete :destroy, id: other_comment, format: :json }
        let(:model) { Comment }
        it_behaves_like 'Does not changeable table size'
        it_behaves_like 'Renderable alert flash message'
        it_behaves_like 'Disable PrivatePub'
      end
    end
  end
end
