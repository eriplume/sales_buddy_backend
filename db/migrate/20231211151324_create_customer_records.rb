class CreateCustomerRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_records do |t|
      t.integer :count, null: false
      t.references :dairy_record, null: false, foreign_key: true
      t.references :customer_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
