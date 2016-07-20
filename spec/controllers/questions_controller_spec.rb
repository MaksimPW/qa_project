require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2)}

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
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
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

      it 'changes question attributes' do
        patch :update, id: question, question: { title: updated_title ,body: updated_body }, format: :js
        question.reload
        expect(question.title).to eq updated_title
        expect(question.body).to eq updated_body
      end

      it 'render update template' do
        patch :update, id: question, question: { title: updated_title, body: updated_body }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Author can`t deletes another author question' do
      it 'does not updates another question' do
        patch :update, id: another_question, question: { title: updated_title ,body: updated_body }, format: :js
        another_question.reload
        expect(another_question.title).to_not eq updated_title
        expect(another_question.body).to_not eq updated_body
      end

      it 'render update template' do
        patch :update, id: another_question, question: { title: updated_title, body: updated_body }, format: :js
        expect(response).to render_template :update
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
      let(:another_question) { create(:question) }

      it 'does not deletes another question' do
        another_question
        expect { delete :destroy, id: another_question }.to_not change(Question, :count)
      end

      it 're-renders current question' do
        delete :destroy, id: another_question
        expect(response).to render_template :show
      end
    end
  end
end
