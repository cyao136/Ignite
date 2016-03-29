class ProjectsController < ApplicationController
	
	####################################################
	# Standard resource methods
	
	def new
		@project = Project.new
	end
	
	def edit
		@project = Project.find(params[:id])
	end
	
	def update
		@project = Project.find(params[:id])
		if @project.update(project_params)
			render "root"
		else
			render "edit"
		end
	end
	
	####################################################
	# create_no_demo
	# create a project that has no demo (stage 1)
	
	def create_no_demo
		@project = Project.new
		if @project.save
		# TODO: Create flash
			flash[:success] = "Project Created Successfully!"
		else
			flash[:error] = "Fail to Create Project!"
		end
	end
	
	####################################################
	# create_has_demo
	# create a project that has a demo (stage 2)
	
	def create_has_demo
		@project = Project.new
		if @project.save
			flash[:success] = "Project Created Successfully!"
		else
			flash[:error] = "Fail to Create Project!"
		end
	end
	
	####################################################
	# submit
	# form submission
	
	def submit
		if params[:create]
		# For project creation
			@project = Project.find(params[:id])
			@project.start_stage_1
			if @project.update(project_params)
				render "new"
			else
				flash[:error] = "Fail to Create Project!"
			end
		else
		# For project saving
			@project = Project.find(params[:id])
			if @project.update(project_params)
				flash[:success] = "Project Saved Successfully!"
			else
				flash[:error] = "Fail to Save Project!"
			end
		end
	end
	
	private
		
		####################################################
		# project params
		# allow the view to modify the parameters
		
		def project_params
			params.require(:project).permit(:name, :small_desc, :full_desc, :team_desc, :creator_desc, :funding)
		end
end
