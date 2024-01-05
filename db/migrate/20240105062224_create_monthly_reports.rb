class CreateMonthlyReports < ActiveRecord::Migration[7.0]
  def change
    create_table :monthly_reports do |t|
      t.text :content, null: false
      t.string :month, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :monthly_reports, [:user_id, :month], unique: true
  end
end
