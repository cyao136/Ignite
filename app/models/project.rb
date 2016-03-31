class Project < ActiveRecord::Base
	has_many :posts
	has_many :demos
	has_many :goals
	has_many :video, as: :asset
	has_many :pictures, as: :asset
	has_and_belongs_to_many :genres
	accepts_nested_attributes_for :demos
	
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
	
	with_options if: :created? do |v|
		v.validates :name, presence: true
	end
	
	with_options if: :not_incomplete? do |v|
		v.validates :small_desc, presence: true
		v.validates :full_desc, presence: true
		v.validates :team_desc, presence: true
		v.validates :creator_desc, presence: true
		v.validates :funding, presence: true
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
