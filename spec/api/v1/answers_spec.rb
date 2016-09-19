require 'rails_helper'

describe 'Answers API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 4, question: question) }
  let(:answer) { answers.first }
  let(:object) { answer }
  let!(:attachment) { create(:attachment, attachable: answer) }
  let(:json_path) { '' }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'auth' do
      let(:json_path) { '0/' }

      it 'returns list of answers' do
        do_request(access_token: access_token.token)
        expect(response.body).to have_json_size(answers.count)
      end

      %w(id body created_at updated_at question_id user_id best score).each do |attr|
        it_behaves_like 'API Checkable eq json attributes', attr
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'

    context 'auth' do

      it 'answer object contains attachment url' do
        do_request(access_token: access_token.token)
        expect(response.body).to be_json_eql(answer.attachments.first.file.url.to_json).at_path("attachments_url/0/")
      end

      %w(id body created_at updated_at question_id user_id best score comments).each do |attr|
        it_behaves_like 'API Checkable eq json attributes', attr
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'auth' do
      let(:object) { assigns(:answer) }

      context 'with valid attributes' do
        it 'saves the new answer in the database' do
          expect { do_request(access_token: access_token.token) }.to change(question.answers, :count).by(1)
        end

        %w(id body created_at updated_at question_id user_id best score).each do |attr|
          it_behaves_like 'API Checkable eq json attributes', attr
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer in the database' do
          expect { do_request(answer: attributes_for(:invalid_answer), access_token: access_token.token) }.to_not change(question.answers, :count)
        end

        it 'response contains errors' do
          do_request(answer: attributes_for(:invalid_answer), access_token: access_token.token)
          expect(response.body).to have_json_path("errors")
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { answer: attributes_for(:answer), question: question, format: :json }.merge(options)
    end
  end
end