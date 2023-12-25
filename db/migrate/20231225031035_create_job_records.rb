class CreateJobRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :job_records do |t|
      t.date :date, null: false
      t.references :user, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true

      t.timestamps
    end
    add_index :job_records, [:user_id, :job_id, :date], unique: true
  end
end
