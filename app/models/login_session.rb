class LoginSession < ApplicationRecord
  belongs_to :user
  validates_presence_of :login_time, :login_ip, :last_access_time, :last_ip
end