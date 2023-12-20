class CreateWeeklyReports < ActiveRecord::Migration[7.0]
  def change
    create_table :weekly_reports do |t|
      t.text :content, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :weekly_reports, [:user_id, :start_date], unique: true
  end
end
