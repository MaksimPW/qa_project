require 'rails_helper'

RSpec.describe SubscriptionsController do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let(:model) { Subscription }

  describe 'POST #create' do
    context 'auth' do
      sign_in_user
      let(:do_request) { post :create, question_id: question, format: :js }
      it_behaves_like 'Changeable table size', 1
    end

    context 'un-auth' do
      let(:do_request) { post :create, question_id: question, format: :js }
      it_behaves_like 'Does not changeable table size'
    end
  end

  describe 'POST #destroy' do
    let!(:subscription) { create(:subscription, user: author, question: question) }

    context 'auth' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in author
      end

      context 'as author' do
        let(:do_request) { delete :destroy, question_id: question, format: :js }
        it_behaves_like 'Changeable table size', -1
      end
    end

    context 'un-auth' do
      let(:do_request) { delete :destroy, question_id: question, format: :js }
      it_behaves_like 'Does not changeable table size'
    end
  end
end