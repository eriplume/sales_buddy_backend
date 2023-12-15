class RemoveUniqueIndexFromDateInDairyRecords < ActiveRecord::Migration[7.0]
  def change
    remove_index :dairy_records, :date
    add_index :dairy_records, [:user_id, :date], unique: true
  end
end
