class RenameColumnInExternalRaitings < ActiveRecord::Migration
  def change
    rename_column :external_ratings, :paring_1, :pairing_1
    rename_column :external_ratings, :paring_2, :pairing_2
    rename_column :external_ratings, :paring_3, :pairing_3
    rename_column :external_ratings, :paring_4, :pairing_4
    rename_column :wines, :paring_4, :pairing_4

  end
end
