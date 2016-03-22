class Project < ActiveRecord::Base
	has_many :posts
	has_many :demos
	has_many :goals
	has_many :video, as: :asset
	has_many :pictures, as: :asset
	has_and_belongs_to_many :genres
	
	enum state: [	:incomplete,
					:stage_1_funding,
					:stage_1_funded,
					:stage_2_funding,
					:stage_2_funded,
					:archived
					]
					
	####################################################
	# start_stage_1
	# Start the stage 1 funding process
	
	def start_stage_1
		# validates the required fields
		# TODO
		
		# set the state to stage_1_funding
		self.state = "stage_1_funding"
	end
end
