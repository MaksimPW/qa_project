require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    sign_in_user

    let(:question) { create(:question) }

    context 'with valid attributes' do
      it 'saves the new answer in the database for Question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to the Question show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(question.answers, :count)
        end

      it 'redirects to the Question show view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) { create(:question) }
    let(:answer) { create(:answer, user: @user, question: question) }
    let(:another_answer) { create(:answer, question: question) }

    context 'Author deletes own answer' do
      it 'deletes answer' do
        answer
        expect { delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by(-1)
      end

      it 'redirect to current question' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'Author can`t deletes another answer' do
      it 'does not deletes another answer' do
        another_answer
        expect { delete :destroy, id: another_answer, question_id: question }.to_not change(Answer, :count)
      end

      it 'rendirect to current question' do
        delete :destroy, id: another_answer, question_id: question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
