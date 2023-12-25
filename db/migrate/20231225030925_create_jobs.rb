class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
