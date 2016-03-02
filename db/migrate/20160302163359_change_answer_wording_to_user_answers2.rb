class ChangeAnswerWordingToUserAnswers2 < ActiveRecord::Migration
  def change
    rename_column :user_answers, :meal, :pairing
  end
end
