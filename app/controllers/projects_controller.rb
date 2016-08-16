class ProjectsController < ApplicationController
	include ProjectsHelper
	before_filter :verify_project_owner, only: [:edit, :update, :submit, :media_upload]
	skip_before_filter :authenticate_user!, only: [:show, :gallery]
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
		else
			redirect_to @project
		end
	end

	def show
		@project = Project.find(params[:id])
    	@embedded_video_link = @project.videos.tagged_with("Main")[0] != nil ? @project.videos.tagged_with("Main")[0].embed_link : ""
		if user_signed_in?
			if @project.unread?(current_user)
				@project.mark_as_read! :for => current_user
				check_quests
				check_badges
			end
		end
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

		# Upload tile picture
		when pictures_button
			if not params[:tile_picture].blank?
				begin
					@project.update(project_params)
					@project.pictures.create!(:asset => params[:tile_picture], :tag_list => "Tile")
					flash.now[:success] = "Pictures Uploaded Successfully!"
				rescue => e
					flash.now[:danger] = e.message
				end
				return render "create"
			end
			flash.now[:warning] = "No Pictures Selected!"
			render "create"

		# Upload main video
		when video_button
			if not params[:video_link].blank?
				vid_id = verify_youtube(params[:video_link])

				if not vid_id then
					flash[:danger] = "Invalid Youtube Link!"
					return render "create"
				end

				embed_link = embed_youtube vid_id
				thumbnail_link = thumbnail_youtube vid_id
				begin
					@project.update(project_params)
					@project.videos.create!({web_id: vid_id, host: "Youtube", embed_link: embed_link, thumbnail_link: thumbnail_link, :tag_list => "Main"})

					flash.now[:success] = "Video Added Successfully!"
					return render "create"
				rescue => e
					flash.now[:danger] = e.message
					return render "create"
				end
			end
			flash.now[:warning] = "No Video Selected!"
			render "create"

		when create_button
			@project.state = "funding"
			if @project.update(project_params)
				flash[:success] = "Project Created!"
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

	# Create external projects (Kickstarter)

	def ext_create
		link = parse_link(params[:project][:crowdfunding_link])
		@project = Project.where(crowdfunding_link: link)[0]
		if @project == nil
			@project = Project.new()
			@project.user_id = current_user.id
			@project.crowdfunding_link = link
			@project.name = "Temp"
			@project.state = "funding_ext"
			if @project.save
			else
				flash.now[:danger] = @project.errors.full_messages.to_sentence
				return render "new"
			end
		end
		parse_kickstarter(@project)
		return redirect_to @project
	end

	def media_destroy
		@project = Project.find(params[:id])
		Pictures.find(params[id]).destroy
		return render "media_upload"
	end

	def media_upload
		@project = Project.find(params[:id])
		@pictures = @project.pictures != nil ? @project.pictures.tagged_with("Gallery") : []
		@videos = @project.videos != nil ? @project.videos.tagged_with("Gallery") : []
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
							@project.pictures.create!(:asset => a, :tag_list => "Gallery")
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
					@project.videos.create!({web_id: vid_id, :tag_list => "Gallery", host: "Youtube", embed_link: embed_link, thumbnail_link: thumbnail_link})

					flash.now[:success] = "Video Added Successfully!"
					return render "media_upload"
				rescue => e
					flash.now[:danger] = e.message
					return render "media_upload"
				end
			end
			flash.now[:warning] = "No Video Selected!"
			render "media_upload"
		end
	end

	def gallery
		@project = Project.find(params[:id])
		@pictures = @project.pictures != nil ? @project.pictures.tagged_with("Gallery") : Array.new
		@videos = @project.videos != nil ? @project.videos.tagged_with("Gallery") : Array.new
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

	def check_quests
    Quest.where(user_id: current_user.id).find_each do |quest|
      if quest.name == "Project" and quest.state == "incomplete"
        quest.complete_quest
      end
    end
  end

  def check_badges
  	if Project.all.read_by(current_user).count == 10
  		current_user.add_badge(3)
  	end
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
