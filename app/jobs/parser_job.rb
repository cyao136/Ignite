class ParserJob < ActiveJob::Base
  queue_as :default

	def perform(projects)
		require 'money'
		require 'open-uri'
		require 'open_uri_redirections'
		params = []
		projects.each do |p|
			begin
				@doc = Nokogiri::HTML(open(p.crowdfunding_link, :allow_redirections => :safe))
			rescue OpenURI::HTTPError => error
				response = error.io
				p response.status
				return
			end
			kickstarter(@doc, p)
		end
	end

	def kickstarter(doc, project)
		require 'money'

		endTime = DateTime.parse(doc.css("#project_duration_data").attr("data-end_time").value)
		duration = doc.css("#project_duration_data").attr("data-duration").value
		startTime = endTime - duration.to_i.days
		funding = Money.new(doc.css("#pledged").attr("data-pledged").value, doc.css("#pledged data").attr('data-currency').value) * 100
		supporter = doc.css("#backers_count").attr("data-backers-count").value
		params = {ended_at: endTime, funding: funding.to_s.to_f, num_supporter: supporter, created_at: startTime}
		project.update(params)
	end
	def indiegogo(doc)
		require 'money'
	end
end
