class ParserJob
	include ProjectsHelper

	def completed()
		completed_projects = Project.where("ended_at < ?", DateTime.now.to_s(:db)).update_all(:state => 'ended')
	end
	handle_asynchronously :completed, :queue => "parser"

	def kickstarter()
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
	handle_asynchronously :kickstarter, :queue => "parser"

  def self.runner
		# Parser Job execution
		parser = ParserJob.new
		parser.kickstarter
		parser.completed
  end
end
