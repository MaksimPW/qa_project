shared_examples_for 'API Checkable eq json attributes' do |attr|
  it "object contains #{attr}" do
    do_request(access_token: access_token.token)
    expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path("#{json_path}#{attr}")
  end
end