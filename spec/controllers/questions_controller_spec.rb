require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let (:question) { create(:question) }

    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question in the database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) { create(:question, user: @user) }

    context 'Author deletes own question' do
      it 'deletes question' do
        question
        expect { delete :destroy, id: question }.to change(@user.questions, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'Author can\`t deletes another author question' do
      let(:another_user) { create(:user) }
      let(:another_question) { create(:question, user: another_user) }

      it 'does not deletes another question' do
        another_question
        expect { delete :destroy, id: another_question }.to_not change(Question, :count)
      end

      it 'redirects to current question' do
        delete :destroy, id: another_question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
