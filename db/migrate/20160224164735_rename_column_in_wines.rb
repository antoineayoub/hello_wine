class RenameColumnInWines < ActiveRecord::Migration
  def change
    rename_column :wines, :cepage_1, :grape_1
    rename_column :wines, :cepage_2, :grape_2
    rename_column :wines, :cepage_3, :grape_3
    rename_column :wines, :cepage_4, :grape_4
    rename_column :wines, :cepage_5, :grape_5
    rename_column :wines, :cepage_6, :grape_6

    add_column :wines, :grape_7, :string
    add_column :wines, :paring_4, :string

    remove_column :wines,  :cepage_percent_1
    remove_column :wines,  :cepage_percent_2
    remove_column :wines,  :cepage_percent_3
  end
end
