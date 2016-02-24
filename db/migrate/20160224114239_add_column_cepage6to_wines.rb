class AddColumnCepage6toWines < ActiveRecord::Migration
  def change
    add_column :wines, :cepage_6, :string
  end
end
