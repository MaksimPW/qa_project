require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:object) { me }

  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'auth' do
      let(:json_path) { '' }

      before { do_request(access_token: access_token.token) }

      %w(id email created_at updated_at).each do |attr|
        it_behaves_like "API Checkable eq json attributes", attr
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
      let(:json_path) { '0/' }
      let!(:list) { create_list :user, 5 }
      let(:object) { list[0] }

      before { do_request(access_token: access_token.token) }

      it 'get index without me' do
        expect(response.body).to eq list.to_json
      end

      %w(id email created_at updated_at).each do |attr|
        it_behaves_like "API Checkable eq json attributes", attr
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