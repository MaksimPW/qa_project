require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'auth' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'auth' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:list) { create_list :user, 5 }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'get index without me' do
        expect(response.body).to eq list.to_json
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(list[0].send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', { format: :json }.merge(options)
    end
  end
end