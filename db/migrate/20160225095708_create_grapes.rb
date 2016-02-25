class CreateGrapes < ActiveRecord::Migration
  def change
    create_table :grapes do |t|
      t.column :name, :string, :null => false
      t.column :acidity, :string
      t.column :body, :string
      t.string :pairing_1, :string
      t.string :pairing_2, :string
      t.string :pairing_3, :string
      t.string :pairing_4, :string
      t.string :pairing_5, :string
      t.string :pairing_6, :string
      t.string :pairing_7, :string

      t.timestamps null: false
    end
  end
end
