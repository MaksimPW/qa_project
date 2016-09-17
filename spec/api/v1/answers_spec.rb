require 'rails_helper'

describe 'Answers API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 4, question: question) }
  let(:answer) { answers.first }
  let!(:attachment) { create(:attachment, attachable: answer) }

  describe 'GET /index' do
    context 'unauth' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'auth' do
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(answers.count)
      end

      %w(id body created_at updated_at question_id user_id best score).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(question.answers.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauth' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'auth' do
      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'answer object contains attachment url' do
        expect(response.body).to be_json_eql(answer.attachments.first.file.url.to_json).at_path("attachments_url/0/")
      end

      %w(id body created_at updated_at question_id user_id best score comments).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(question.answers.first.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauth' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'auth' do
      it 'response 200 status' do
        post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), question: question, access_token: access_token.token, format: :json
        expect(response).to be_success
      end

      context 'with valid attributes' do
        it 'saves the new answer in the database' do
          expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), question: question, access_token: access_token.token, format: :json }.to change(question.answers, :count).by(1)
        end

        %w(id body created_at updated_at question_id user_id best score).each do |attr|
          it "answer object contains #{attr}" do
            post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), question: question, access_token: access_token.token, format: :json
            expect(response.body).to be_json_eql(assigns(:answer).send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer in the database' do
          expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), question: question, access_token: access_token.token, format: :json }.to_not change(question.answers, :count)
        end

        it 'response contains errors' do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), question: question, access_token: access_token.token, format: :json
          expect(response.body).to have_json_path("errors")
        end
      end
    end
  end
end