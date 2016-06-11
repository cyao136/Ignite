class ParserJob < ActiveJob::Base
  queue_as :default

	def perform(projects)
		require 'money'
		require 'open-uri'
		require 'open_uri_redirections'
		params = []
		projects.each do |proj|
			begin
				@doc = Nokogiri::HTML(open(proj.crowdfunding_link, :allow_redirections => :safe))
				p @doc.css("html").attr("class").value 
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
			endTime = DateTime.parse(doc.css("#project_duration_data").attr("data-end_time").value)
			duration = doc.css("#project_duration_data").attr("data-duration").value
			startTime = endTime - duration.to_i.days
			funding = Money.new(doc.css("#pledged").attr("data-pledged").value, doc.css("#pledged data").attr('data-currency').value) * 100
			supporter = doc.css("#backers_count").attr("data-backers-count").value
			params = {ended_at: endTime, funding: funding.to_s.to_f, num_supporter: supporter, created_at: startTime}
			project.update(params)
			p 'hello ok'
		end
		p 'fail'
	end
	def indiegogo(doc)
		require 'money'
	end
end
