class CreateWeeklyTargets < ActiveRecord::Migration[7.0]
  def change
    create_table :weekly_targets do |t|
      t.integer :target, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :weekly_targets, [:user_id, :start_date], unique: true
  end
end
