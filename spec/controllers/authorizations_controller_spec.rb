require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  describe 'POST #create' do
    context 'omniauth session present' do
      before do
        auth_hash = {
            provider: 'facebook',
            uid: '1234567',
            info: {}
        }
        session['omniauth'] = OmniAuth::AuthHash.new(auth_hash)
      end

      context 'valid email' do
        before { post :create, email: 'user_example@example.com' }

        it 'store email in omniauth session' do
          expect(session['omniauth']['info']['email']).to eq 'user_example@example.com'
        end

        it 'render notice flash message' do
          expect(flash[:notice]).to be_present
        end
      end

      context 'invalid email' do
        before { post :create, email: '@example.comuser_example' }

        it 'render error flash message' do
          expect(flash[:error]).to be_present
        end
      end
    end

    context 'omniauth session not present' do
      before { post :create, email: 'user_example@example.com' }

      it 'render error flash message' do
        expect(flash[:error]).to be_present
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end