require 'acceptance_helper'

feature 'User can comment question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  given(:replica_comment) { create(:comment, commentable: question) }
  given!(:comment) { create(:comment, commentable: question, user: user) }
  given!(:other_comment) { create(:comment, commentable: question) }
  given!(:comments) { create_list(:comment, 3, commentable: question) }

  context 'As Auth' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'See list comments for question' do
      comments.each do |c|
        expect(page).to have_content c.body
      end
    end

    scenario 'Create valid comment for question', :js do
      within '.question' do
        click_on 'Add Comment'
        fill_in 'comment_body', with: replica_comment.body
        click_button 'Create Comment'

        expect(page).to have_content replica_comment.body
      end
    end

    scenario 'Create invalid comment for question', :js do
      within '.question' do
        click_on 'Add Comment'
        click_button 'Create Comment'
      end

      expect(page).to have_content 'Body can\'t be blank'
      expect(page).to_not have_content replica_comment.body
    end

    scenario 'Delete own comment for question', :js do
      within "*[data-comment-id='#{comment.id}']" do
        click_link 'Delete'
      end
      expect(page).to_not have_content comment.body
    end

    scenario 'Delete other comment for question', :js do
      within "*[data-comment-id='#{other_comment.id}']" do
        expect(page).to_not have_content 'Delete'
      end
    end
  end

  context 'As Un-Auth' do
    scenario 'Can`t create comment for question', :js do
      visit question_path(question)
      expect(page).to_not have_content 'Add Comment'
    end
  end
end