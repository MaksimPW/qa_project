shared_examples_for 'Changeable table size' do |count|
  it 'change record count in the database' do
    expect { do_request }.to change(model, :count).by(count)
  end
end

shared_examples_for 'Does not changeable table size' do
  it 'does not change record count in the database' do
    expect { do_request }.to_not change(model, :count)
  end
end

shared_examples_for 'Renderable templates' do |template|
  it 'renders template' do
    do_request
    expect(response).to render_template template
  end
end

shared_examples_for 'Renderable json true' do
  it 'render json true' do
    do_request
    json = JSON.parse(response.body)
    expect(json).to be_truthy
  end
end

shared_examples_for 'Renderable json empty' do
  it 'render json empty' do
    do_request
    expect(response.body).to be_empty
  end
end

shared_examples_for 'Renderable alert flash message' do
  it 'render alert flash message if error' do
    do_request
    expect(flash[:alert]).to be_truthy
  end
end