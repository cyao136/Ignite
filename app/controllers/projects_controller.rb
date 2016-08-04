class ProjectsController < ApplicationController
	include ProjectsHelper
	before_filter :verify_project_owner, only: [:edit, :update, :submit, :media_upload]

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
		redirect_to @project
	end

	def show
      @project = Project.find(params[:id])
    	@new_comment = Comment.build_from(@project, current_user.id, "")
  end

	####################################################
	# create
	# create a project

	def create
		@project = Project.new(project_params)
		@project.user_id = current_user.id
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
		case params[:commit]
		# For project creation
		when create_button
			# Currently only have external projects
			@project.state = "funding_ext"
			if @project.update(project_params)
				flash[:success] = "Project Created!"
				ParserJob.perform_later([@project])
				redirect_to @project
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
		# For creating pledge
		# when pledge_button
		# 	@project.update(project_params)
		# 	begin
		# 		@project.pledges.create!(
		# 			project_id: @project.id,
		# 			name: params[:pledge_name],
		# 			description: params[:pledge_desc],
		# 			max_number: params[:pledge_max],
		# 			cost: params[:pledge_cost]
		# 			)
		# 		flash.now[:success] = "Pledge Created Successfully!"
		# 		return render "create"
		# 	rescue => e
		# 		flash.now[:danger] = e.message
		# 		return render "create"
		# 	end
		# 	render "create"
		end
	end

	def media_destroy
		@project = Project.find(params[:id])
		Pictures.find(params[id]).destroy
		return render "media_upload"
	end

	def media_upload
		@project = Project.find(params[:id])
		@pictures = @project.pictures != nil ? @project.pictures : []
		@videos = @project.videos != nil ? @project.videos : []
		case params[:commit]

		when delete_picture_button
			if not params[:picture_id].blank?
				begin
					@picture = Picture.find(params[:picture_id])
					@picture.destroy!
					return redirect_to "media_upload"
				rescue => e
				end
			end
		# For uploading demo
		when demo_button
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
					return render "media_upload"
				rescue => e
					flash.now[:danger] = e.message
					return render "media_upload"
				end
			end
			flash.now[:warning] = "No Demo Selected!"
			render "media_upload"
		# For uploading pictures
		when pictures_button
			if not params[:picture_assets].blank?
				params[:picture_assets].each do |a|
					if not a.blank?
						begin
							@project.pictures.create!(:asset => a)
							flash.now[:success] = "Pictures Uploaded Successfully!"
						rescue => e
							flash.now[:danger] = e.message
						end
					end
				end
				return render "media_upload"
			end
			flash.now[:warning] = "No Pictures Selected!"
			render "media_upload"
		# For uploading video
		when video_button
			
			#if not params[:video_asset].blank?
			#	begin
			#		@project.videos.create!(:asset => params[:video_asset])
			#		flash.now[:success] = "Video Uploaded Successfully!"
			#		return render "media_upload"
			#	rescue => e
			#		flash.now[:danger] = e.message
			#		return render "media_upload"
			#	end
			#end

			if not params[:video_link].blank?
				vid_id = verify_youtube(params[:video_link])
				
				if not vid_id then
					flash[:danger] = "Invalid Youtube Link!"
					return render "media_upload"
				end

				embed_link = embed_youtube vid_id
				thumbnail_link = thumbnail_youtube vid_id
				begin
					@project.videos.create!({web_id: vid_id, host: "Youtube", embed_link: embed_link, thumbnail_link: thumbnail_link})
					
					flash.now[:success] = "Video Added Successfully!"
					return render "media_upload"
				rescue => e
					flash.now[:danger] = e.message
					return render "media_upload"
				end

				flash.now[:warning] = "No Video Selected!"
				render "media_upload"
			end
		end
	end

	def gallery
		@project = Project.find(params[:id])
		@pictures = @project.pictures != nil ? @project.pictures : Array.new
		@videos = @project.videos != nil ? @project.videos : Array.new
	end

	def discussion
		@project = Project.find(params[:id])
    	@new_comment = Comment.build_from(@project, current_user.id, "")
	end

	def discussion_general
		@project = Project.find(params[:id])
		@comments = @project.root_comments.tagged_with("general").paginate(:page => params[:page])
  	@new_comment = Comment.build_from(@project, current_user.id, "")
  	@new_comments = @project.comment_threads.tagged_with("general")
	end

	def discussion_bugs
		@project = Project.find(params[:id])
		@comments = @project.root_comments.tagged_with("bugs").paginate(:page => params[:page])
  	@new_comment = Comment.build_from(@project, current_user.id, "")
  	@new_comments = @project.comment_threads.tagged_with("bugs")
	end

	def discussion_suggestions
		@project = Project.find(params[:id])
		@comments = @project.root_comments.tagged_with("suggestions").paginate(:page => params[:page])
  	@new_comment = Comment.build_from(@project, current_user.id, "")
  	@new_comments = @project.comment_threads.tagged_with("suggestions")
	end

	def feedback
		@project = Project.find(params[:id])
		@comments = @project.root_comments.tagged_with("feedback").paginate(:page => params[:page])
	  @new_comment = Comment.build_from(@project, current_user.id, "")
  	@new_comments = @project.comment_threads.tagged_with("feedback")
	end

	private

		####################################################
		# project params
		# allow the view to modify the parameters

		def project_params
			params.require(:project).permit(:id, :name, :small_desc, :full_desc, :creator_name, :creator_desc,
				:funding, :state, :num_supporter, :embeded_video_link, :crowdfunding_link, :facebook_link,
				:twitter_link, :website_link, :tag_list, videos_attributes: [:web_id, :host, :embed_link, :thumbnail_link],
				demos_attributes: [:name, :version, :asset], pictures_attributes: [:asset => []])
		end

end
