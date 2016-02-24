class CorrectAnswerWordingToUserAnswers < ActiveRecord::Migration
  def change
    rename_column :user_answers, :answser1, :answer1
    rename_column :user_answers, :answser2, :answer2
    rename_column :user_answers, :answser3, :answer3
  end
end
