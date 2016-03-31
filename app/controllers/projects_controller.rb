class ProjectsController < ApplicationController
	####################################################
	# Standard resource methods
	
	def new
		@project = Project.new
		@project.demos.build
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
	# create
	# create a project
	
	def create
		@project = Project.new(user_id: current_user.id)
		@has_demo = params[:demo]
		if @project.save
			flash[:success] = "Let's build your project together!"
		else
			flash.now[:danger] = @project.errors.full_messages.to_sentence
			render "new"
		end
	end
	
	####################################################
	# submit_basic_info
	# submitting basic project informations
	
	def submit_basic_info
		@has_demo = params[:has_demo]
		# For project creation
		if params[:create]
			@project = Project.find(params[:id])
			if @project.update(project_params)
				flash[:success] = "Basic Info Saved!"
				if @has_demo
					render "demo_upload"
				else
					render "new"
				end
			else
				render "create"
			end
		# For project saving
		else
			@project = Project.find(params[:id])
			if @project.update(project_params)
				flash[:success] = "Project Saved Successfully!"
				render "create"
			else
				render "create"
			end
		end
	end
		
	####################################################
	# upload_demo
	# upload a demo of the game
	
	def upload_demo
		@project = Project.find(params[:id])
		@demo = Demo.new(demo_params)
		@demo.project_id = @project.id
		if @demo.save
			flash[:success] = "The demo was added!"
			render 'new'
		else
			flash[:danger] = @demo.errors.full_messages.to_sentence
			render 'demo_upload'
		end
	end

	
	private
		
		####################################################
		# project params
		# allow the view to modify the parameters
		
		def project_params
			params.require(:project).permit(:name, :small_desc, :full_desc, :team_desc, :creator_desc, :funding, :state)
		end
		
		def demo_params
			params.require(:demo).permit(:name, :version, :asset)
		end
end
