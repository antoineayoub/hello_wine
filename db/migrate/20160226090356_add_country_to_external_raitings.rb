class AddCountryToExternalRaitings < ActiveRecord::Migration
  def change
    add_column :external_ratings, :country, :string
  end
end
