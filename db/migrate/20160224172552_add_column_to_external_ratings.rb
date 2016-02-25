class AddColumnToExternalRatings < ActiveRecord::Migration
  def change

    add_column :external_ratings, :color, :string
    add_column :external_ratings, :name, :string
    add_column :external_ratings, :vintage, :string
    add_column :external_ratings, :description, :string
    add_column :external_ratings, :region, :string
    add_column :external_ratings, :appellation, :string
    add_column :external_ratings, :acidity, :string
    add_column :external_ratings, :alcohol_percent, :string
    add_column :external_ratings, :body, :string

    add_column :external_ratings, :grape_1, :string
    add_column :external_ratings, :grape_2, :string
    add_column :external_ratings, :grape_3, :string
    add_column :external_ratings, :grape_4, :string
    add_column :external_ratings, :grape_5, :string
    add_column :external_ratings, :grape_6, :string
    add_column :external_ratings, :grape_7, :string

    add_column :external_ratings, :paring_1, :string
    add_column :external_ratings, :paring_2, :string
    add_column :external_ratings, :paring_3, :string
    add_column :external_ratings, :paring_4, :string

    add_column :external_ratings, :photo, :string

    rename_column :external_ratings, :nb_ratings, :rating_count
    rename_column :external_ratings, :wine_info, :winery
  end
end
