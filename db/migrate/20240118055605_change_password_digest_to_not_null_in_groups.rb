class ChangePasswordDigestToNotNullInGroups < ActiveRecord::Migration[7.0]
  def change
    change_column_null :groups, :password_digest, false
  end
end
