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
	# submit a project to start the funding
	
	def submit
		@project = Project.find(params[:id])
		@project.start_stage_1
		if @project.update(project_params)
		  render "new"
		else
		  flash[:error] = "Fail to Create Project!"
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
