class RenameWineTitleFromExternalRatings < ActiveRecord::Migration
  def change
    rename_column :external_ratings, :wine_title, :wine_info
  end
end
