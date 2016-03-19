class User < ActiveRecord::Base
	has_many :posts
	has_one :picture, as: :asset
	has_and_belongs_to_many :pledges
	before_save { self.email = email.downcase }
	validates :username, presence: true, :length => { :in => 4..12 }, uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, :length => { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	has_secure_password
end
