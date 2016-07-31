class AddScoreToAnswersAndQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :score, :integer, default: 0, index: true
    add_column :answers, :score, :integer, default: 0, index: true
  end
end
