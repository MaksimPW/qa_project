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
      let!(:other_comment) { create(:comment, commentable: question) }

      it 'author can delete his comment for Question' do
        expect { delete :destroy, id: question_comment, format: :json }.to change(question.comments, :count).by(-1)
      end

      it 'author can delete his comment for User' do
        expect { delete :destroy, id: question_comment, format: :json }.to change(@user.comments, :count).by(-1)
      end

      it 'author can\'t delete other comment for Comment' do
        expect { delete :destroy, id: other_comment, format: :json }.to_not change(Comment, :count)
      end

      it 'render json' do
        delete :destroy, id: question_comment, format: :json
        json = %({"id": #{question_comment.id}})
        expect(response.body).to be_json_eql json
      end

      it 'render error' do
        delete :destroy, id: other_comment, format: :json
        json = %({"error": "You can't remove not own comment"})
        expect(response.body).to be_json_eql json
      end

      it 'response 403 if error' do
        delete :destroy, id: other_comment, format: :json
        expect(response.status).to eq 403
      end
    end

    context 'answer' do
      let!(:answer_comment) { create(:comment, user: @user, commentable: answer) }
      let!(:other_comment) { create(:comment, commentable: answer) }

      it 'author can delete his comment for Answer' do
        expect { delete :destroy, id: answer_comment, format: :json }.to change(answer.comments, :count).by(-1)
      end

      it 'author can delete his comment for User' do
        expect { delete :destroy, id: answer_comment, format: :json }.to change(@user.comments, :count).by(-1)
      end

      it 'author can\'t delete other comment for Comment' do
        expect { delete :destroy, id: other_comment, format: :json }.to_not change(Comment, :count)
      end

      it 'render json' do
        delete :destroy, id: answer_comment, format: :json
        json = %({"id": #{answer_comment.id}})
        expect(response.body).to be_json_eql json
      end

      it 'render error' do
        delete :destroy, id: other_comment, format: :json
        json = %({"error": "You can't remove not own comment"})
        expect(response.body).to be_json_eql json
      end

      it 'response 403 if error' do
        delete :destroy, id: other_comment, format: :json
        expect(response.status).to eq 403
      end
    end
  end
end
