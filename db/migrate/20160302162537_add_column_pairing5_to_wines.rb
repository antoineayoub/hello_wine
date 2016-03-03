class AddColumnPairing5ToWines < ActiveRecord::Migration
  def change
    add_column :wines, :pairing_5, :string
  end
end
