shared_examples_for 'Vote as auth user' do
  scenario 'can see rate' do
    within "#{css_selector}" do
      expect(page).to have_content('0')
    end
  end

  scenario 'can up vote' do
    within "#{css_selector}" do
      find('.vote-up').click
      expect(page).to have_css('.vote-up.active')
      expect(page).to have_content('1')
    end
  end

  scenario 'can down vote' do
    within "#{css_selector}" do
      find('.vote-down').click
      expect(page).to have_css('.vote-down.active')
      expect(page).to have_content('-1')
    end
  end

  scenario 'can undo vote' do
    within "#{css_selector}" do
      find('.vote-up').click
      find('.vote-up.active').click

      expect(page).to_not have_css('.vote-up.active')
      expect(page).to have_content('0')
    end
  end

  scenario 'can re-vote' do
    within "#{css_selector}" do
      find('.vote-up').click
      find('.vote-up').click
      find('.vote-up').click

      expect(page).to have_css('.vote-up.active')
      expect(page).to have_content('1')
    end
  end
end

shared_examples_for 'Vote as un-auth user' do
  background do
    visit question_path(question)
  end

  scenario 'can see rate' do
    within "#{css_selector}" do
      expect(page).to have_content('0')
    end
  end

  scenario 'can`t vote' do
    expect(page).to_not have_content('.vote-up')
    expect(page).to_not have_content('.vote-down')
  end
end