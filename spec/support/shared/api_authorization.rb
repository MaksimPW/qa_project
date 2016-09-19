shared_examples_for 'API Authenticable' do
  context 'unauth' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access token is invalid' do
      do_request(access_token: '1234')
      expect(response.status).to eq 401
    end
  end

  context 'auth' do
    it 'returns 200 status' do
      do_request(access_token: access_token.token)
      expect(response).to be_success
    end
  end
end