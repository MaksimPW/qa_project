require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  describe 'POST #create' do
    sign_in_user

    let(:question) { create(:question) }
    let(:model) { question.answers }

    context 'with valid attributes' do
      let(:do_request) { post :create, answer: attributes_for(:answer), question_id: question, format: :js }

      it_behaves_like 'Changeable table size', 1

      let(:model) { @user.answers }
      it_behaves_like 'Changeable table size', 1

      it_behaves_like 'Renderable templates', :create
    end

    context 'with invalid attributes' do
      let(:do_request) { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }
      let(:model) { question.answers }

      it_behaves_like 'Does not changeable table size'
      it_behaves_like 'Renderable templates', :create
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let!(:question) { create (:question) }
    let(:answer) { create(:answer, user: @user, question: question) }
    let(:answer_updated_body) { answer.body + 'updated' }
    let(:another_answer) { create(:answer, question: question) }

    context 'Author updates own answer' do
      let(:do_request) { patch :update, id: answer, answer: attributes_for(:answer), question_id: question, format: :js }

      it 'assigns the requested answer to @answer' do
        do_request
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question' do
        do_request
        expect(assigns(:question)).to eq question
      end

      let(:do_request) { patch :update, id: answer, answer: { body: answer_updated_body }, question_id: question, format: :js }

      it 'changes answer attributes' do
        do_request
        answer.reload
        expect(answer.body).to eq answer_updated_body
      end

      it_behaves_like 'Renderable templates', :update
    end

    context 'Author can`t updates another answer' do
      it 'does not updates another answer' do
        patch :update, id: another_answer, answer: { body: answer_updated_body }, question_id: question, format: :js
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
      let(:do_request) { patch :best, id: answer.id, question_id: question, format: :js }

      it 'set best answer is true' do
        do_request
        answer.reload
        expect(answer.best).to be_truthy
      end

      it 'question can not have a lot of best answers' do
        do_request
        first_best_answer.reload
        expect(first_best_answer.best).to be_falsey
      end

      it_behaves_like 'Renderable templates', :best
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
    let!(:answer) { create(:answer, user: @user, question: question) }
    let!(:another_answer) { create(:answer, question: question) }
    let(:model) { Answer }

    context 'Author deletes own answer' do
      let(:do_request) { delete :destroy, id: answer, question_id: question, format: :js }

      it_behaves_like 'Changeable table size', -1
      it_behaves_like 'Renderable templates', :destroy
    end

    context 'Author can`t deletes another answer' do
      let(:do_request) { delete :destroy, id: another_answer, question_id: question, format: :js }
      it_behaves_like 'Does not changeable table size'
    end
  end
end
