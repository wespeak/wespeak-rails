class User < ActiveRecord::Base

  include Constants

  # foreign key relationships

  has_many :email_addresses

  # attr_accessors

  attr_accessor :email

  # password stuff

  has_secure_password

  
  # validations

  validates :name, presence: true, length: { maximum: Lengths::USER_NAME_MAX }, uniqueness: true

  validates :password, length: { minimum: Lengths::PASSWORD_MIN }
end
