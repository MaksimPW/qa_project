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