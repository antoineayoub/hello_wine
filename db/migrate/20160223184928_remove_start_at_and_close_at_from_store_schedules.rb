class RemoveStartAtAndCloseAtFromStoreSchedules < ActiveRecord::Migration
  def change
    remove_column :store_schedules, :start_at, :time
    remove_column :store_schedules, :close_at, :time
  end
end
