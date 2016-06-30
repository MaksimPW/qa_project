require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'with valid attributes' do
      it 'saves the new answer in the database for Question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer, question_id: question) }.to change(Answer, :count).by(1)
      end

      it 'redirects to the Question show view' do
        post :create, question_id: question, answer: attributes_for(:answer, question_id: question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer, question_id: question) }.to_not change(Answer, :count)
        end

      it 'redirects to the Question show view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer, question_id: question)
        expect(response).to redirect_to question_path(assigns(:question))
        # TODO: Add render error message for invalid answer
      end
    end
  end
end
