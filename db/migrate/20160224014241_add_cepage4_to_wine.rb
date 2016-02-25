class AddCepage4ToWine < ActiveRecord::Migration
  def change
    add_column :wines, :cepage_4, :string
  end
end
