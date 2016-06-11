class BrowseController < ApplicationController
	skip_before_action :require_login

	####################################################
	# category
	# browse projects in a category
	
	def category
		@cur_genre = params[:genre]
		@cur_sort = params[:sort]
		if params[:genre] == 'All'
			@projects = Project.where(state: 5) + Project.where(state: 2)
		else
			@projects = Project.tagged_with(params[:genre]).where(state: 5) + Project.tagged_with(params[:genre]).where(state: 2)
		end

		case params[:sort]
		when "random"
			@projects = @projects.shuffle
		when "newest"
			@projects = @projects.sort{ |b,a| a.created_at <=> b.created_at }
		when "most_popular"
			@projects = @projects.sort{ |b,a| a.num_supporter <=> b.num_supporter }
		when "soon_ending"
			@projects = @projects.sort{ |a,b| a.ended_at <=> b.ended_at }
		end
	end

	####################################################
	# search
	# search projects
	
	def search
		@projects = Project.where("name like ?", "%#{params[:name]}%")
		if params[:genres] == ''
			@projects = @projects.where(state: 5) + @projects.where(state: 2)
		else
			@genres = params[:genres].split(',')
			@projects = @projects.tagged_with(@genres).where(state: 5) + @projects.tagged_with(@genres).where(state: 2)
		end

		case params[:sort]
		when "random"
			@projects = @projects.shuffle
		when "newest"
			@projects = @projects.sort{ |b,a| a.created_at <=> b.created_at }
		when "most_popular"
			@projects = @projects.sort{ |b,a| a.num_supporter <=> b.num_supporter }
		when "soon_ending"
			@projects = @projects.sort{ |a,b| a.ended_at <=> b.ended_at }
		end
	end
end