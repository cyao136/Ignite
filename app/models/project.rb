class Project < ActiveRecord::Base
	has_many :posts
	has_many :demos
	has_many :goals
	has_many :video, as: :asset
	has_many :pictures, as: :asset
	has_and_belongs_to_many :genres
end
