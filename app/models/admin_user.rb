# The admin user
class AdminUser < ActiveRecord::Base
  # Include devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :recoverable
  devise :database_authenticatable, :token_authenticatable, :omniauthable,
         :rememberable, :trackable, :validatable

  attr_accessor :email, :password
end
