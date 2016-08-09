class ParserJob < ActiveJob::Base
	include ProjectsHelper
	queue_as :default

	def perform(projects)
		require 'open-uri'
		require 'open_uri_redirections'
		params = []
		projects.each do |proj|
			begin
				@doc = Nokogiri::HTML(open(proj.crowdfunding_link, :allow_redirections => :safe))
			rescue => e
				p e
				return
			end
			kickstarter(@doc, proj)
		end
	end

	def kickstarter(doc, project)
		require 'money'
		if doc.css("html").attr("class").value.include? "projects_show"
			begin
				endTime = DateTime.parse(doc.css("#project_duration_data").attr("data-end_time").value)
				duration = doc.css("#project_duration_data").attr("data-duration").value
				startTime = endTime - duration.to_i.days
				funding = Money.new(doc.css("#pledged").attr("data-pledged").value, doc.css("#pledged data").attr('data-currency').value) * 100
				supporter = doc.css("#backers_count").attr("data-backers-count").value
				creator = doc.css(".remote_modal_dialog")[0].children.text
				small_desc = doc.css(".h3").children.text
				name = doc.css(".green-dark").children[0].text

				embed_video_link = "https://www.kickstarter.com/" + doc.css(".green-dark").attr("href").value + "/widget/video.html"
				project.videos.create!({:embed_link => embed_video_link, :tag_list => "Main"})
				
				card_link = "https://www.kickstarter.com/" + doc.css(".green-dark").attr("href").value + "/widget/card.html"
				card_doc = Nokogiri::HTML(open(card_link, :allow_redirections => :safe))
				pic_link = card_doc.css(".project-thumbnail-img").attr("src").value
				open('temp-tile.png', 'wb') do |file|
					file << open(pic_link).read
					project.pictures.create!({asset: file, :tag_list => "Tile"})
				end
				#doc.css("iframe").each do |video|
				#	project.videos.create!({:embed_link => video.attr("src"), :tag_list => "Gallery"})
				#end

				params = {name: name, small_desc: small_desc, creator_name: creator, ended_at: endTime, funding: funding.to_s.to_f, num_supporter: supporter, created_at: startTime}
				if not project.update(params)
					p project.errors.full_messages.to_sentence
				end
			rescue => e
				p e
				return
			end
		end
	end

	def indiegogo(doc)
	end
end
