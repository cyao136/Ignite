class Project < ActiveRecord::Base
	belongs_to :user
	acts_as_taggable
	acts_as_commentable
	has_many :posts, :dependent => :destroy
	has_many :demos, :dependent => :destroy
	has_many :pledges
	has_many :videos, :dependent => :destroy
	has_many :pictures, as: :assetable, :dependent => :destroy
	accepts_nested_attributes_for :demos
	accepts_nested_attributes_for :pictures
	accepts_nested_attributes_for :videos

	enum state: [
					:incomplete,
					:funding,
					:funded,
					:archived,
					:deleted,
					:funding_ext
				]
	
	# Validations
	validates :user_id, presence: true
	validates :name, presence: true, length: { minimum: 4, maximum: 64 }
	validates :small_desc, length: { maximum: 150 }
	validates :full_desc, length: { maximum: 5000 }
	validates :creator_desc, length: { maximum: 1000 }
	

	with_options if: :not_incomplete? do |v|
		v.validates :small_desc, presence: true, length: { minimum: 2 }
		v.validates :full_desc, presence: true, length: { minimum: 2 }
		v.validates :creator_desc, presence: true, length: { minimum: 2 }
		v.validates :creator_name, presence: true, length: { minimum: 2 }
	end

	with_options if: ->o {o.is_state? "funding_ext"} do |v|
		v.validates :crowdfunding_link, presence: true, length: { minimum: 2 }
	end

	def not_incomplete?
		state != "incomplete" && state != "funding_ext"
	end

	def is_state?(s)
		state == s
	end

	def created?
		created_at != nil
	end
end
