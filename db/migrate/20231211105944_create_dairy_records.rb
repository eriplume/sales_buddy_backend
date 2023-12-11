class CreateDairyRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :dairy_records do |t|
      t.integer :total_amount, null: false
      t.integer :total_number, null: false
      t.integer :count, null: false
      t.float :set_rate, null: false
      t.float :average_spend, null: false
      t.date :date, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
