class User < ActiveRecord::Base
	has_many :posts
	has_one :picture, as: :asset
	has_and_belongs_to_many :pledges
end
