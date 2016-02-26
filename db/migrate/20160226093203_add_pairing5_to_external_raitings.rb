class AddPairing5ToExternalRaitings < ActiveRecord::Migration
  def change
    add_column :external_ratings, :pairing_5, :string
  end
end
