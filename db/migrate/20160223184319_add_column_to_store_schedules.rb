class AddColumnToStoreSchedules < ActiveRecord::Migration
  def change
    add_column :store_schedules, :start_am, :time
    add_column :store_schedules, :end_am, :time
    add_column :store_schedules, :start_pm, :time
    add_column :store_schedules, :end_pm, :time
  end
end
