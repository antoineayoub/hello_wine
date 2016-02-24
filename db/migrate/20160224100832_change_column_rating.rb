class ChangeColumnRating < ActiveRecord::Migration
  def change
    change_column :user_ratings, :rating, :float
    change_column :external_ratings, :avg_rating, :float
    change_column :external_ratings, :nb_ratings, :integer
  end
end
