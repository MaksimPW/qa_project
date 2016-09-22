shared_examples_for 'Commentable' do
  context 'As Auth', :js do
    given!(:comments) { create_list(:comment, 3, commentable: model, user: user) }
    given(:comment_body) { create(:comment, commentable: model) }
    given(:comment) { comments.first }
    given!(:other_comment) { create(:comment, commentable: model) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'See list comments for object', :js do
      within "#{object_css}" do
        comments.each do |c|
          expect(page).to have_content c.body
        end
      end
    end

    scenario 'Can`t see list comments for other objects', :js do
      within "#{other_object_css}"do
        comments.each do |c|
          expect(page).to_not have_content c.body
        end
      end
    end

    scenario 'Create valid comment for object', :js do
      within "#{object_css}" do
        click_link 'Add Comment'
        fill_in 'comment_body', with: comment_body.body
        click_button 'Create Comment'

        expect(page).to have_content comment_body.body
      end
    end

    scenario 'Create invalid comment for object', :js do
      within "#{object_css}" do
        click_link 'Add Comment'
        click_button 'Create Comment'

        expect(page).to have_content 'can\'t be blank'
        expect(page).to_not have_content comment_body.body
      end
    end

    scenario 'Create comment only for object', :js do
      within "#{object_css}" do
        click_link 'Add Comment'
        fill_in 'comment_body', with: comment_body.body
        click_button 'Create Comment'
      end

      within "#{other_object_css}" do
        expect(page).to_not have_content comment_body.body
      end
    end

    scenario 'Delete own comment for objectr', :js do
      within "*[data-comment-id='#{comment.id}']" do
        click_link 'Delete'
      end
      expect(page).to_not have_content comment.body
    end

    scenario 'Delete other comment for object', :js do
      within "*[data-comment-id='#{other_comment.id}']" do
        expect(page).to_not have_content 'Delete'
      end
    end
  end

  context 'As Un-Auth' do
    scenario 'Can`t create comment for object', :js do
      visit question_path(question)
      expect(page).to_not have_content 'Add Comment'
    end
  end
end