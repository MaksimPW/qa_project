require 'acceptance_helper'

feature 'User can comment answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
  given!(:other_answer) { create(:answer, question: question) }
  given(:replica_comment) { create(:comment, commentable: answer) }

  context 'As Auth' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'See list comments for answer', :js do
      within "#answer_#{answer.id}" do
        comments.each do |c|
          expect(page).to have_content c.body
        end
      end
    end

    scenario 'Can`t see list comments for other answer', :js do
      within "#answer_#{other_answer.id}" do
        comments.each do |c|
          expect(page).to_not have_content c.body
        end
      end
    end

    scenario 'Create valid comment for answer', :js do
      within "#answer_#{answer.id}" do
        click_link 'Add Comment'
        fill_in 'comment_body', with: replica_comment.body
        click_button 'Create Comment'

        expect(page).to have_content replica_comment.body
      end
    end

    scenario 'Create invalid comment for answer', :js do
      within "#answer_#{answer.id}" do
        click_link 'Add Comment'
        click_button 'Create Comment'

        expect(page).to have_content 'Body can\'t be blank'
        expect(page).to_not have_content replica_comment.body
      end
    end

    scenario 'Create comment only for @answer', :js do
      within "#answer_#{answer.id}" do
        click_link 'Add Comment'
        fill_in 'comment_body', with: replica_comment.body
        click_button 'Create Comment'
      end

      within "#answer_#{other_answer.id}" do
        expect(page).to_not have_content replica_comment.body
      end

      within '.question' do
        expect(page).to_not have_content replica_comment.body
      end
    end

    scenario 'Delete own comment for answer', :js do
      within "*[data-comment-id='#{comments.first.id}']" do
        click_link 'Delete'
      end
      expect(page).to_not have_content comments.first.body
    end

    scenario 'Delete other comment for answer', :js do
      within "#answer_#{other_answer.id}" do
        expect(page).to_not have_content 'Delete'
      end
    end
  end

  context 'As Un-Auth' do
    scenario 'Can`t create comment for answer', :js do
      visit question_path(question)
      expect(page).to_not have_content 'Add Comment'
    end
  end
end