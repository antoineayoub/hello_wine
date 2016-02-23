class CreateUserRatings < ActiveRecord::Migration
  def change
    create_table :user_ratings do |t|
      t.string :status
      t.integer :rating
      t.references :user, index: true, foreign_key: true
      t.references :wine, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
