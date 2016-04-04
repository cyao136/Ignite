module ProjectsHelper

	include SessionsHelper
	####################################################
	# project_id
	# get the id of the current project instance
	
	def project_id
		@project.id
	end
	def project_owner
		@project.user_id
	end
end
