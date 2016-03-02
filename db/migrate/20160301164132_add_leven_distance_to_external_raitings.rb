class AddLevenDistanceToExternalRaitings < ActiveRecord::Migration
  def change
    add_column :external_ratings, :len_distance, :float
    remove_column :grapes, :string
  end
end
