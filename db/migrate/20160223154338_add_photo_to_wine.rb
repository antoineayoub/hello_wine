class AddPhotoToWine < ActiveRecord::Migration
  def change
    add_column :wines, :photo, :string
  end
end
