class Project < ActiveRecord::Base
	has_many :posts
	has_many :demos
	has_many :goals
	has_many :videos, as: :assetable
	has_many :pictures, as: :assetable
	has_and_belongs_to_many :genres
	accepts_nested_attributes_for :demos
	accepts_nested_attributes_for :pictures
	accepts_nested_attributes_for :videos

	enum state: [
					:incomplete,
					:stage_1_funding,
					:stage_1_funded,
					:stage_2_funding,
					:stage_2_funded,
					:archived
				]
	
	# Validations
	validates :user_id, presence: true
	validates :name, presence: true, length: { minimum: 4, maximum: 32 }
	
	with_options if: :not_incomplete? do |v|
		v.validates :small_desc, presence: true, length: { minimum: 2, maximum: 50 }
		v.validates :full_desc, presence: true, length: { minimum: 2, maximum: 5000 }
		v.validates :team_desc, presence: true, length: { minimum: 2, maximum: 1000 }
		v.validates :creator_desc, presence: true, length: { minimum: 2, maximum: 1000 }
		v.validates :funding, presence: true
		v.validates_presence_of :pictures
	end
	
	with_options if: :stage_2_funding? do |v|
		v.validates_presence_of :demos
	end
	
	def not_incomplete?
		state != "incomplete"
	end
	
	def created?
		created_at != nil
	end
end
