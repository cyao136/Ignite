class ProjectsController < ApplicationController
	include ProjectsHelper
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
	
	def show
      @project = Project.find(params[:id])
    end
	
	####################################################
	# create
	# create a project
	
	def create
		@project = Project.new(project_params)
		@project.user_id = current_user.id
		@has_demo = nil
		if params[:demo]
			@has_demo = true
		end
		if @project.save
			flash.now[:success] = "Let's build your project together!"
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
		p @has_demo
		case params[:commit]
		# For project creation
		when create_button
			@project.state = "stage_1_funding"
			if @has_demo
				@project.state = "stage_2_funding"
			end
			if @project.update(project_params)
				flash[:success] = "Project Created!"
				redirect_to root_url
			else
				render "create"
			end
		# For project saving
		when save_button
			if @project.update(project_params)
				flash.now[:success] = "Project Saved Successfully!"
				render "create"
			else
				flash.now[:danger] = "Fail to Save Project!"
				render "create"
			end
		# For uploading demo
		when demo_button
			@project.update(project_params)
			if not params[:demo_asset].blank?
				begin 
					@project.demos.create!(
						:asset => params[:demo_asset],
						:name => params[:demo_name],
						:version => params[:demo_version],
						:is_active => true,
						:project_id => @project.id
						)
					
					flash.now[:success] = "Demo Uploaded Successfully!"
					return render "create"
				rescue => e
					flash.now[:danger] = e.message
					return render "create"
				end
			end
			flash.now[:warning] = "No Demo Selected!"
			render "create"
		# For uploading pictures
		when pictures_button
			@project.update(project_params)
			if not params[:pictures].blank?
				params[:pictures].each do |a|
					if not a.blank?
						begin
							@project.pictures.create!(:asset => a)
							flash.now[:success] = "Pictures Uploaded Successfully!"
							return render "create"
						rescue => e
							flash.now[:danger] = e.message
							return render "create"
						end
					end
				end
			end
			flash.now[:warning] = "No Pictures Selected!"
			render "create"
		# For uploading video
		when video_button
			@project.update(project_params)
			if not params[:video].blank?
				begin
					@project.videos.create!(:asset => params[:video])
					flash.now[:success] = "Video Uploaded Successfully!"
					return render "create"
				rescue => e
					flash.now[:danger] = e.message
					return render "create"
				end
			end
			flash.now[:warning] = "No Video Selected!"
			render "create"
		# For creating pledge
		when pledge_button
			@project.update(project_params)
			begin
				@project.pledges.create!(
					project_id: @project.id,
					name: params[:pledge_name],
					description: params[:pledge_desc],
					max_number: params[:pledge_max],
					cost: params[:pledge_cost]
					)
				flash.now[:success] = "Pledge Created Successfully!"
				return render "create"
			rescue => e
				flash.now[:danger] = e.message
				return render "create"
			end
			render "create"
		end
	end

	
	private
		
		####################################################
		# project params
		# allow the view to modify the parameters
		
		def project_params
			params.require(:project).permit(:id, :name, :small_desc, :full_desc, :team_desc, :creator_desc, :funding, :state)
		end
end
