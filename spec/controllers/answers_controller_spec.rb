require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  describe 'POST #create' do
    sign_in_user

    let(:question) { create(:question) }

    context 'with valid attributes' do
      it 'saves the new answer in the database for Question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'saves the new answer in the database for User' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(question.answers, :count)
        end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let!(:question) { create (:question) }
    let(:answer) { create(:answer, user: @user, question: question) }
    let(:answer_updated_body) { answer.body + 'updated' }
    let(:another_answer) { create(:answer, question: question) }

    context 'Author updates own answer' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer: { body: answer_updated_body }, format: :js
        answer.reload
        expect(answer.body).to eq answer_updated_body
      end

      it 'render update template' do
        patch :update, id: answer, question_id: question, answer: { body: answer_updated_body }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Author can`t updates another answer' do
      it 'does not updates another answer' do
        patch :update, id: another_answer, question_id: question, answer: { body: answer_updated_body }, format: :js
        another_answer.reload
        expect(another_answer.body).to_not eq answer_updated_body
      end
    end
  end

  describe 'POST #best' do
    sign_in_user

    let(:question) { create(:question, user: @user)}
    let(:first_best_answer) { create(:answer, question: question) }
    let(:answer) { create(:answer, question: question) }
    let(:another_answer) { create(:answer, question: create(:question)) }

    context 'Author of question can set best answer' do
      it 'set best answer is true' do
        patch :best, id: answer.id, question_id: question, format: :js
        answer.reload
        expect(answer.best).to be_truthy
      end

      it 'question can not have a lot of best answers' do
        patch :best, id: answer.id, question_id: question, format: :js
        first_best_answer.reload
        expect(first_best_answer.best).to be_falsey
      end

      it 'render best template' do
        patch :best, id: answer.id, question_id: question, format: :js
        expect(response).to render_template :best
      end
    end

    context 'Author can`t set best answer for another question' do
      it 'can`t set best answer' do
        patch :best, id: another_answer.id, question_id: another_answer.question_id, format: :js
        another_answer.reload
        expect(another_answer.best).to be_falsey
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
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Author can`t deletes another answer' do
      it 'does not deletes another answer' do
        another_answer
        expect { delete :destroy, id: another_answer, question_id: question, format: :js }.to_not change(Answer, :count)
      end
    end
  end
end
