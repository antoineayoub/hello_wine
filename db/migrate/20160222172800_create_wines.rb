class CreateWines < ActiveRecord::Migration
  def change
    create_table :wines do |t|
      t.string :color
      t.string :name
      t.string :vintage
      t.string :cepage_1
      t.string :cepage_2
      t.string :cepage_3
      t.float :cepage_percent_1
      t.float :cepage_percent_2
      t.float :cepage_percent_3
      t.references :store, index: true, foreign_key: true
      t.string :pairing_1
      t.string :pairing_2
      t.string :pairing_3
      t.string :description
      t.string :appellation
      t.string :region
      t.string :acidity
      t.float :alcohol_percent
      t.float :avg_rating

      t.timestamps null: false
    end
  end
end
