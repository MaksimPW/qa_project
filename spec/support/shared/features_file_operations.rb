shared_examples_for 'Able file operations for create' do
  scenario 'Adds file', :js do
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on I18n.t("helpers.submit.#{model}.create")

    within "#{object_css}" do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end

  scenario 'Adds multiply files', :js do
    click_on I18n.t('cocoon.defaults.add')

    within "#{new_object_css}" do
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
      inputs[1].set("#{Rails.root}/spec/spec_helper.rb")
    end

    click_button I18n.t("helpers.submit.#{model}.create")

    expect(page).to have_xpath("//a[contains(.,'rails_helper.rb')]")
    expect(page).to have_xpath("//a[contains(.,'spec_helper.rb')]")
  end

  scenario 'Removes one file', :js do
    click_on I18n.t('cocoon.defaults.add')

    within "#{new_object_css}" do
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
      inputs[1].set("#{Rails.root}/spec/spec_helper.rb")
    end

    first('.attachment-file').click_on(I18n.t('cocoon.defaults.remove'))

    click_button I18n.t("helpers.submit.#{model}.create")

    expect(page).to_not have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end
end

shared_examples_for 'Able file operations for edit' do
  scenario 'Removes file of question', :js do
    within "#{objects_css}" do
      click_on I18n.t('cocoon.defaults.remove')
      click_on I18n.t("helpers.submit.#{model}.update")
    end

    expect(page).to_not have_link attachment.file.identifier
  end

  scenario 'See current files', :js do
    within '.attachment-file' do
      expect(page).to have_content attachment.file.identifier
      expect(page).to have_link I18n.t('cocoon.defaults.remove')
    end
  end

  scenario 'Adds file', :js do
    within "#{object_css}" do
      click_on I18n.t('cocoon.defaults.add')
      attach_file('File', "#{Rails.root}/spec/rails_helper.rb")
      click_on I18n.t("helpers.submit.#{model}.update")
      expect(page).to have_xpath("//a[contains(.,'rails_helper.rb')]")
    end
  end
end