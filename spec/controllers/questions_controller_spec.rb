require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2)}
    let(:do_request) { get :index }

    before { do_request }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it_behaves_like 'Renderable templates', :index
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    let(:do_request) { get :show, id: question }

    before { do_request }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it_behaves_like 'Renderable templates', :show
  end

  describe 'GET #new' do
    sign_in_user
    let(:do_request) { get :new }

    before { do_request }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it_behaves_like 'Renderable templates', :new
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:do_request) { post :create, question: attributes_for(:question) }
      let(:model) { @user.questions }

      it_behaves_like 'Changeable table size', 1
      it_behaves_like 'Able PrivatePub'

      it 'redirects to show view' do
        do_request
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:do_request) { post :create, question: attributes_for(:invalid_question) }
      let(:model) { Question }

      it_behaves_like 'Does not changeable table size'
      it_behaves_like 'Renderable templates', :new
      it_behaves_like 'Disable PrivatePub'
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let(:question) { create(:question, user: @user) }
    let(:updated_title) { question.title + 'updated' }
    let(:updated_body) { question.body + 'updated' }
    let(:another_question) { create(:question, user: create(:user)) }

    context 'Author updates own question' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      let(:do_request) { patch :update, id: question, question: { title: updated_title ,body: updated_body }, format: :js }

      it 'changes question attributes' do
        do_request
        question.reload
        expect(question.title).to eq updated_title
        expect(question.body).to eq updated_body
      end

      it_behaves_like 'Renderable templates', :update
    end

    context 'Author can`t deletes another author question' do
      it 'does not updates another question' do
        patch :update, id: another_question, question: { title: updated_title ,body: updated_body }, format: :js
        another_question.reload
        expect(another_question.title).to_not eq updated_title
        expect(another_question.body).to_not eq updated_body
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'Author deletes own question' do
      let!(:question) { create(:question, user: @user) }
      let(:do_request) { delete :destroy, id: question }
      let(:model) { @user.questions }

      it_behaves_like 'Changeable table size', -1

      it 'redirects to index view' do
        do_request
        expect(response).to redirect_to questions_path
      end
    end

    context 'Author can\`t deletes another author question' do
      let!(:another_question) { create(:question) }
      let(:do_request) { delete :destroy, id: another_question }
      let(:model) { Question }

      it_behaves_like 'Does not changeable table size'
    end
  end
end
