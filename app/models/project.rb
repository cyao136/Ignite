class Project < ActiveRecord::Base
	has_many :posts, :dependent => :destroy
	has_many :demos, :dependent => :destroy
	has_many :goals, :dependent => :destroy
	has_many :pledges
	has_many :videos, as: :assetable, :dependent => :destroy
	has_many :pictures, as: :assetable, :dependent => :destroy
	has_and_belongs_to_many :genres
	accepts_nested_attributes_for :demos
	accepts_nested_attributes_for :pictures
	accepts_nested_attributes_for :videos
	accepts_nested_attributes_for :pledges

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
	validates :small_desc, length: { maximum: 50 }
	validates :full_desc, length: { maximum: 5000 }
	validates :team_desc, length: { maximum: 1000 }
	validates :creator_desc, length: { maximum: 1000 }
	
	with_options if: :not_incomplete? do |v|
		v.validates :small_desc, presence: true, length: { minimum: 2 }
		v.validates :full_desc, presence: true, length: { minimum: 2 }
		v.validates :team_desc, presence: true, length: { minimum: 2 }
		v.validates :creator_desc, presence: true, length: { minimum: 2 }
		v.validates :funding, presence: true
		v.validates_presence_of :pictures
		v.validates_presence_of :pledges
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
