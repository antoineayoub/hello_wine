class AddColumnsToExternalRatings < ActiveRecord::Migration
  def change
    add_column :external_ratings, :wine_title, :string
    add_column :external_ratings, :wine_name, :string
  end
end
