class ChangeGroupIdNullConstraintInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :group_id, true
  end
end
