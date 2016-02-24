class AddPriceToWine < ActiveRecord::Migration
  def change
    add_column :wines, :price, :float
  end
end
