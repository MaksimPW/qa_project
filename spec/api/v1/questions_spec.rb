require 'rails_helper'

describe 'Questions API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let!(:questions) { create_list(:question, 2) }
  let(:question) { questions.first }
  let!(:answer) { create(:answer, question: question) }

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'auth' do
      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:comment) { create(:comment, commentable: question) }
    let!(:attachment) { create(:attachment, attachable: question) }
    let!(:attachment_answer) { create(:attachment, attachable: answer) }

    it_behaves_like "API Authenticable"

    context 'auth' do
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'question object contains attachment url' do
        expect(response.body).to be_json_eql(question.attachments.first.file.url.to_json).at_path("attachments_url/0/")
      end

      %w(id body title created_at updated_at comments).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
          end
        end

        it 'answer object contains attachment url' do
          expect(response.body).to be_json_eql(answer.attachments.first.file.url.to_json).at_path("answers/0/attachments_url/0/")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'auth' do
      it 'returns 200 status code' do
        post '/api/v1/questions', question: attributes_for(:question), access_token: access_token.token, format: :json
        expect(response).to be_success
      end

      context 'with valid attributes' do
        it 'saves the new question in the database' do
          expect { post '/api/v1/questions', question: attributes_for(:question), access_token: access_token.token, format: :json }.to change(Question, :count).by(1)
        end

        %w(id body title created_at updated_at user_id).each do |attr|
          it "question object contains #{attr}" do
            post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:question)
            expect(response.body).to be_json_eql(assigns(:question).send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question in the database' do
          expect { post '/api/v1/questions', question: attributes_for(:invalid_question), access_token: access_token.token, format: :json }.to_not change(Question, :count)
        end

        it 'response contains errors' do
          post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:invalid_question)
          expect(response.body).to have_json_path("errors")
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end
  end
end