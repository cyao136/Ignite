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
	end
	
	def edit
		@project = Project.find(params[:id])
	end
	
	def update
		@project = Project.find(params[:id])
		if not @project.update(project_params)
			render 'edit'
			flash.now[:danger] = @project.errors.full_messages.to_sentence
		end
	end
	
	####################################################
	# create
	# create a project
	
	def create
		@project = Project.new(project_params)
		@project.user_id = current_user.id
		@has_demo = false
		if params[:demo]
			@has_demo = true
		end
		if @project.save
			flash[:success] = "Let's build your project together!"
		else
			flash.now[:danger] = @project.errors.full_messages.to_sentence
			render "new"
		end
	end
	
	####################################################
	# submit
	# submitting project informations
	
	def submit
		@project = Project.find(params[:id])
		@has_demo = params[:has_demo]
		# For project creation
		if params[:create]
			@project.state = "stage_1_funding"
			if @has_demo
				@project.state = "stage_2_funding"
			end
			if @project.update(project_params)
				params[:demos_attachments]['asset'].each do |a|
          			@demo = @project.demos_attachments.create!(:asset => a)
       			end
				flash[:success] = "Basic Info Saved!"
				redirect_to root_url
			else
				render "create"
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

	
	private
		
		####################################################
		# project params
		# allow the view to modify the parameters
		
		def project_params
			params.require(:project).permit(:id, :name, :small_desc, :full_desc, :team_desc, :creator_desc, :funding, :state,
				demos_attributes: [:id, :project_id, :asset],
				pictures_attributes: [:name, :assetable_id, :assetable_type, :asset],
				videos_attributes: [:name, :assetable_id, :assetable_type, :asset])
		end
end
