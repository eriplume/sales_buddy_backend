class AddUniqueIndexToDateInDairyRecords < ActiveRecord::Migration[7.0]
  def change
    add_index :dairy_records, :date, unique: true
  end
end
