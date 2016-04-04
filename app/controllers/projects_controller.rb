class ProjectsController < ApplicationController
	before_filter :verify_project_owner
  	skip_before_filter :verify_project_owner, only: [:new, :create]

	def verify_project_owner
		if current_user.id != Project.find(params[:id]).user_id
			redirect_to root_url
		end
	end
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
		@project = Project.new(project_params)
		@project.user_id = current_user.id
		puts params[:demo]
		@has_demo = false
		if params[:demo]
			@has_demo = true
		end
		puts @has_demo
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
		@project = Project.find(params[:id])
		@has_demo = params[:has_demo]
		# For project creation
		if params[:create]
			if @project.update(project_params)
				flash[:success] = "Basic Info Saved!"
				if @has_demo
					render "demo_upload"
				else
					render "new"
				end
			else
				render "picture_video_upload"
			end
		# For project saving
		else
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
			render 'picture_video_upload'
		else
			flash[:danger] = @demo.errors.full_messages.to_sentence
			render 'demo_upload'
		end
	end

	####################################################
	# upload_picture
	# upload pictures of the project
	
	def upload_picture
		@project = Project.find(params[:id])
		@picture = Picture.new(picture_params)
		if @picture.save
			flash[:success] = "The picture was added!"
			render 'new'
		else
			flash[:danger] = @picture.errors.full_messages.to_sentence
			render 'new'
		end
	end

	
	private
		
		####################################################
		# project params
		# allow the view to modify the parameters
		
		def project_params
			params.require(:project).permit(:name, :small_desc, :full_desc, :team_desc, :creator_desc, :funding, :state, :demos_attributes)
		end
		
		def demo_params
			params.require(:demo).permit(:name, :version, :asset)
		end

		def picture_params
			params.require(:picture).permit(:asset)
		end
end
