class AddCompletionToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :is_completed, :boolean, default: false
    add_reference :tasks, :completed_by, foreign_key: { to_table: :users }
  end
end
