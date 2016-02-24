class RemoveStoreIdFromWines < ActiveRecord::Migration
  def change
    remove_reference :wines, :store
  end
end
