class AddBrandToStores < ActiveRecord::Migration
  def change
    add_column :stores, :brand, :string
  end
end
