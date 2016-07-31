class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value
      t.integer :votable_id, null: false
      t.string :votable_type
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :votes, [:votable_id, :votable_type, :user_id]
  end
end
