class ParserJob < ActiveJob::Base
	include ProjectsHelper
	queue_as :default

	def perform(projects)
		params = []
		projects.each do |proj|
			begin
				kickstarter(proj.crowdfunding_link, proj)
			rescue => e
				p e
				return
			end
		end
	end

	def kickstarter(link, project)
		require 'money'
		begin
			sub_url = /projects[^\?]++/.match(link).to_s

			client = Kickscraper.client

			slug = sub_url.split('/').last

			kproj = client.find_project(slug)

			name = kproj.name
			small_desc = kproj.blurb
			funding = Money.new(kproj.pledged, kproj.currency) * 100
			supporter = kproj.backers_count

			endTime = Time.at(kproj.deadline)
			startTime = Time.at(kproj.launched_at)
			updated_at = Time.at(kproj.updated_at)

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

			params = {name: name, small_desc: small_desc, creator_name: creator, ended_at: endTime, funding: funding.to_s.to_f, num_supporter: supporter, updated_at: updated_at, created_at: startTime}

			if not project.update(params)
				p project.errors.full_messages.to_sentence
			end
		rescue => e
			return e
		end
	end

	def indiegogo(doc)
	end
end
