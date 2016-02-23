class CreateExternalRatings < ActiveRecord::Migration
  def change
    create_table :external_ratings do |t|
      t.integer :avg_rating
      t.float :nb_ratings
      t.references :wine, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
