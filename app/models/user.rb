class User < ApplicationRecord
  has_secure_password
  has_many :projects
  has_many :labels
  validates :password, length: { minimum: 8, allow_blank: true }
  validates :email, presence: true
  validates_uniqueness_of :email
end
