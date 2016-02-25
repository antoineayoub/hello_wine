class RemoveBrandFromStores < ActiveRecord::Migration
  def change
    remove_column :stores, :brand, :string
  end
end
