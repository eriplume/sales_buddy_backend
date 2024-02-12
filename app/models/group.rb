class Group < ApplicationRecord
  has_secure_password
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  has_many :users, dependent: :nullify
  has_many :tasks, dependent: :destroy
end
