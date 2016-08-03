module ProjectsHelper

	####################################################
	# project_id
	# get the id of the current project instance
	
	def project_id
		@project.id
	end
	def project_owner
		@project.user_id
	end
	def current_project
		@project
	end


	####################################################
	# button value for the cases in submit
	# !!! each value needs to be different
	def demo_button
		"Upload Demo"
	end
	def pictures_button
		"Upload Pictures"
	end
	def video_button
		"Upload Video"
	end
	def pledge_button
		"Add Pledge"
	end
	def create_button
		"Create Project!"
	end
	def save_button
		"Save Project"
	end
	def delete_picture_button
		"Delete"
	end
	
	def has_facebook?()
		@project.facebook_link=='' ? "disabled" : ""
  	end

	def has_twitter?()
		@project.twitter_link=='' ? "disabled" : ""
  	end

	def has_website?()
		@project.website_link=='' ? "disabled" : ""
  	end

  	def popular_tags()
  		num_limit = 7
  		@tags = Array.new(num_limit)
  		Project.tag_counts_on(:tags).limit(num_limit).map{|t| tags.push(t.name)}
  		return @tags
  	end

  	#######################################################
  	# Video Link Parsing
  	

	def verify_youtube link
		reg = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/
		match = reg.match(link)
		# TODO: More extensive verification
		return (match&&match[7].length==11)? match[7] : false
	end

	def embed_youtube id
		return "https://www.youtube.com/embed/" + id
	end

	def thumbnail_youtube id
		return "http://img.youtube.com/vi/" + id + "/default.jpg"
	end
end
