class CreateStoreSchedules < ActiveRecord::Migration
  def change
    create_table :store_schedules do |t|
      t.references :store, index: true, foreign_key: true
      t.time :start_at
      t.time :close_at
      t.integer :day

      t.timestamps null: false
    end
  end
end
