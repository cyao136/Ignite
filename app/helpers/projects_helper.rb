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

  	def parse_genre(text)
  		# A map of keywords (in lowercase) to genres
  		genres_hash = {
  			"2d" => "2D",
  			"action" => "Action",
  			"adventure" => "Adventure",
  			"explor" => "Adventure",
  			"casual" => "Casual",
  			"dating" => "Dating",
  			"fantasy" => "Fantasy",
  			"fps" => "FPS",
  			"first person shooter" => "FPS",
  			"mobile" => "Mobile",
  			"multiplayer" => "Multiplayer",
  			"puzzl" => "Puzzle",
  			"solve" => "Puzzle",
  			"racing" => "Racing",
  			"race" => "Racing",
  			"retro" => "Retro",
  			"8bit" => "Retro",
  			"8-bit" => "Retro",
  			"rogue-like" => "Rogue-like",
  			"rpg" => "RPG",
  			"role play" => "RPG",
  			"platformer" => "Platformer",
  			"sci-fi" => "Sci-Fi",
  			"science fiction" => "Sci-Fi",
  			"science-fiction" => "Sci-Fi",
  			"sim" => "Simulation",
  			"sport" => "Sport",
  			"strategy" => "Strategy",
  			"rts" => "Strategy",
  			"survival" => "Survival",
  			"survive" => "Survival",
  			"virtual reality" => "VR",
  			"oculus" => "VR",
  			"htc vive" => "VR",
  			"vr" => "VR"
  		}
  		tags = []
  		blob = text.downcase
  		genres_hash.each do |k, v|
  			if blob.include?(k) then
  				tags << v
  			end
  		end
  		if tags.blank? then
  			tags = ["Unknown"]
  		end
  		return tags.uniq
  	end


  	def parse_link link
  		# Kickstarter link removes ?ref... from the url
  		/https[^\?]++/.match(link).to_s
  	end

	def parse_kickstarter(project)
		require 'money'
		begin
			sub_url = /projects[^\?]++/.match(project.crowdfunding_link).to_s

			client = Kickscraper.client

			slug = sub_url.split('/').last

			kproj = client.find_project(slug)

			name = kproj.name
			small_desc = kproj.blurb
			tag_list = parse_genre(name + ' ' + small_desc)
			funding = Money.new(kproj.pledged, kproj.currency) * 100
			supporter = kproj.backers_count

			endTime = Time.at(kproj.deadline)
			startTime = Time.at(kproj.launched_at)

			creator = kproj.creator.name
			if project.videos.tagged_with("Main").empty? then
				embed_video_link = "https://www.kickstarter.com/" + sub_url + "/widget/video.html"
				project.videos.create!({:embed_link => embed_video_link, :tag_list => "Main"})
			end

			if project.pictures.tagged_with("Tile").empty? then
				pic_link = kproj.photo['full']
				open('temp-tile.png', 'wb') do |file|
					file << open(pic_link).read
					project.pictures.create!({asset: file, :tag_list => "Tile"})
				end
			end

			params = {name: name, small_desc: small_desc, tag_list: tag_list, creator_name: creator, ended_at: endTime, funding: funding.to_s.to_f, num_supporter: supporter, created_at: startTime}

			if not project.update(params)
				p project.errors.full_messages.to_sentence
			end
		rescue => e
			return e
		end
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
