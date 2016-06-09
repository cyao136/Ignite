module ProjectsHelper

	####################################################
	# project_id
	# get the id of the current project instance
	
	def project_id
		@project.id
	end
	def project_owner
		@project.user_id
	end
	def current_project
		@project
	end


	####################################################
	# button value for the cases in submit
	# !!! each value needs to be different
	def demo_button
		"Upload Demo"
	end
	def pictures_button
		"Upload Pictures"
	end
	def video_button
		"Upload Video"
	end
	def pledge_button
		"Add Pledge"
	end
	def create_button
		"Create Project!"
	end
	def save_button
		"Save Project"
	end
	
	def has_facebook?()
		@project.facebook_link=='' ? "disabled" : ""
  	end

	def has_twitter?()
		@project.twitter_link=='' ? "disabled" : ""
  	end

	def has_website?()
		@project.website_link=='' ? "disabled" : ""
  	end
end
