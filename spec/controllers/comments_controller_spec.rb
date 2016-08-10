require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  sign_in_user
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  let(:comment) { create(:comment, user: @user) }
  let(:invalid_comment) { create(:invalid_comment) }

  describe 'POST #create' do
    context 'question' do
      it 'assigns to @question' do
        post :create, question_id: question, comment: attributes_for(:comment), format: :json
        expect(assigns(:commentable_object)).to eq question
      end

      it 'saves the new comment in the database for Question' do
        expect { post :create, question_id: question, comment: attributes_for(:comment), format: :json }.to change(question.comments, :count).by(1)
      end

      it 'saves the new comment in the database for User' do
        expect { post :create, question_id: question, comment: attributes_for(:comment), format: :json }.to change(@user.comments, :count).by(1)
      end

      it 'render json' do
        post :create, question_id: question, comment: attributes_for(:comment), format: :json
        json = JSON.parse(response.body)
        expect(json).to be_truthy
      end

      it 'render json errors' do
        post :create, question_id: question, comment: attributes_for(:invalid_comment), format: :json
        json = %({"errors": ["Body can't be blank", "Body is too short (minimum is 15 characters)"]})
        expect(response.body).to be_json_eql json
      end
    end

    context 'answer' do
      it 'assigns to @answer' do
        post :create, answer_id: answer, comment: attributes_for(:comment), format: :json
        expect(assigns(:commentable_object)).to eq answer
      end

      it 'saves the new comment in the database for Answer' do
        expect { post :create, answer_id: answer, comment: attributes_for(:comment), format: :json }.to change(answer.comments, :count).by(1)
      end

      it 'saves the new comment in the database for User' do
        expect { post :create, answer_id: answer, comment: attributes_for(:comment), format: :json }.to change(@user.comments, :count).by(1)
      end

      it 'render json' do
        post :create, answer_id: answer, comment: attributes_for(:comment), format: :json
        json = JSON.parse(response.body)
        expect(json).to be_truthy
      end

      it 'render json errors' do
        post :create, answer_id: answer, comment: attributes_for(:invalid_comment), format: :json
        json = %({"errors": ["Body can't be blank", "Body is too short (minimum is 15 characters)"]})
        expect(response.body).to be_json_eql json
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'question' do
      let!(:question_comment) { create(:comment, user: @user, commentable: question) }

      it 'author can delete his comment for Question' do
        expect { delete :destroy, id: question_comment, format: :json }.to change(question.comments, :count).by(-1)
      end

      it 'author can delete his comment for User' do
        expect { delete :destroy, id: question_comment, format: :json }.to change(@user.comments, :count).by(-1)
      end

      it 'render json' do
        delete :destroy, id: question_comment, format: :json
        json = %({"id": #{question_comment.id}})
        expect(response.body).to be_json_eql json
      end

      it 'render json errors' do
        delete :destroy, id: question_comment, format: :json
        delete :destroy, id: question_comment, format: :json
        json = %({"errors": "Not found"})
        expect(response.body).to be_json_eql json
      end
    end

    context 'answer' do
      let!(:answer_comment) { create(:comment, user: @user, commentable: answer) }

      it 'author can delete his comment for Answer' do
        expect { delete :destroy, id: answer_comment, format: :json }.to change(answer.comments, :count).by(-1)
      end

      it 'author can delete his comment for User' do
        expect { delete :destroy, id: answer_comment, format: :json }.to change(@user.comments, :count).by(-1)
      end

      it 'render json' do
        delete :destroy, id: answer_comment, format: :json
        json = %({"id": #{answer_comment.id}})
        expect(response.body).to be_json_eql json
      end

      it 'render json errors' do
        delete :destroy, id: answer_comment, format: :json
        delete :destroy, id: answer_comment, format: :json
        json = %({"errors": "Not found"})
        expect(response.body).to be_json_eql json
      end
    end
  end
end
