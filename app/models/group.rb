class Group < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  has_many :users, dependent: :nullify

  before_destroy :assign_default_group_to_users, unless: -> { id == default_group_id }

  private

  def assign_default_group_to_users
    default_group_id = 1 # デフォルトのgroup_id
    users.find_each do |user|
      user.update(group_id: default_group_id)
    end
  end
end
