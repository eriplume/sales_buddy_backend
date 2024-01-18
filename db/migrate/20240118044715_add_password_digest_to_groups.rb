class AddPasswordDigestToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :password_digest, :string
  end
end
