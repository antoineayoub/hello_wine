class ChangeAnswerWordingToUserAnswers < ActiveRecord::Migration
  def change
    rename_column :user_answers, :question1, :meal
    rename_column :user_answers, :question2, :color
    rename_column :user_answers, :question3, :price
  end
end
