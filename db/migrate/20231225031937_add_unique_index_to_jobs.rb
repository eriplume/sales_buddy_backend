class AddUniqueIndexToJobs < ActiveRecord::Migration[7.0]
  def change
    add_index :jobs, :name, unique: true
  end
end
