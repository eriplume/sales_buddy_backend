class AddTaskNotificationsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :task_notifications, :boolean, default: false
  end
end
