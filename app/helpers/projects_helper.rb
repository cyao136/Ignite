module ProjectsHelper

	####################################################
	# project_id
	# get the id of the current project instance
	
	def project_id
		@project.id
	end
	
	def update_project
		@project.update
	end
end
