class RemoveMessagesAndRooms < ActiveRecord::Migration[7.0]
  def change
    drop_table :messages if table_exists?(:messages)
    drop_table :rooms if table_exists?(:rooms)
  end
end
