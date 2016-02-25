class AddBrandRefenreceToStores < ActiveRecord::Migration
  def change
    add_reference :stores, :brand, index: true
  end
end
