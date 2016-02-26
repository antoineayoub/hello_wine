class AddPriceToExternalRaitings < ActiveRecord::Migration
  def change
    add_column :external_ratings, :price, :float
  end
end
