class UpdateJob
	include ProjectsHelper

	def update_projects()
		Project.where(:state => "funding_ext").each do |p|
			parse_kickstarter(p)
		end
	end
	handle_asynchronously :update_projects, :queue => "update_projects"

  def self.runner
		# Parser Job execution
		update = UpdateJob.new
		update.update_projects
  end
end
