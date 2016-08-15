class ParserJob < ActiveJob::Base
	include ProjectsHelper
	queue_as :default

	def perform()
		params = []
		client = Kickscraper.client
		projects = []
		projects = projects + client.search_projects("", nil, 35, 'live')

		while client.more_projects_available? do
			projects = projects + client.load_more_projects
		end

		projects.each do |proj|
			begin
				link = parse_link(proj.urls['web']['project'])
				@project = Project.where(crowdfunding_link: link)[0]
				if @project == nil
					@project = Project.new()
					@project.user_id = 1 #TODO needs to use an admin account
					@project.crowdfunding_link = link
					@project.name = "Temp"
					@project.state = "funding_ext"
					if @project.save
					else
						p @project.errors.full_messages.to_sentence
					end
				end
				parse_kickstarter(@project)
			rescue => e
				p e
			end
		end
		to_update = Project.where("updated_at < ?", DateTime.now.to_s(:db))

		to_update.each do |proj|
			parse_kickstarter(proj)
		end
	end
end
