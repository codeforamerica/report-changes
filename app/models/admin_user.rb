class AdminUser < ApplicationRecord
  devise :otp_authenticatable, :database_authenticatable,
         :recoverable, :rememberable, :validatable, :trackable, :lockable
end
