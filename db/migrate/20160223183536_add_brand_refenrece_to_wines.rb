class AddBrandRefenreceToWines < ActiveRecord::Migration
  def change
    add_reference :wines, :brand, index: true
  end
end
