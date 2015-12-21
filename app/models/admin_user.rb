# The admin user
class AdminUser < ActiveRecord::Base
  # Include devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :recoverable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessor :email, :password
end
