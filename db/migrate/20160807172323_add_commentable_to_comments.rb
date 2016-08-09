class AddCommentableToComments < ActiveRecord::Migration
  def change
    add_column :comments, :commentable_id, :integer, null: false
    add_column :comments, :commentable_type, :string

    add_index :comments, [:commentable_id, :commentable_type, :user_id], name: :index_comments_on_user_id_and_commentable
  end
end
