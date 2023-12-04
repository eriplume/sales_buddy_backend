class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :line_id, null: false
      t.boolean :notifications, default: false
      t.integer :role, default: 0, null: false
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
