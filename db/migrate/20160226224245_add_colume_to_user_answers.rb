class AddColumeToUserAnswers < ActiveRecord::Migration
  def change
    add_column :user_answers, :latitude, :float
    add_column :user_answers, :longitude, :float
  end
end
