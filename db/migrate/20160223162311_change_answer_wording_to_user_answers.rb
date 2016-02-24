class ChangeAnswerWordingToUserAnswers < ActiveRecord::Migration
  def change
    rename_column :user_answers, :answer1, :meal
    rename_column :user_answers, :answer2, :color
    rename_column :user_answers, :answer3, :price
  end
end
