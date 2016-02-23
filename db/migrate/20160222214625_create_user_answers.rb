class CreateUserAnswers < ActiveRecord::Migration
  def change
    create_table :user_answers do |t|
      t.string :question1
      t.string :question2
      t.string :question3
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
