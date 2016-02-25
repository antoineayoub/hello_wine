class AddCepage5ToWine < ActiveRecord::Migration
  def change
    add_column :wines, :cepage_5, :string
  end
end
