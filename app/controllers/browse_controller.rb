class BrowseController < ApplicationController
	skip_before_filter :authenticate_user!

	####################################################
	# category
	# browse projects in a category

	def category
		@cur_genre = params[:genre]
		@cur_sort = params[:sort] || "random"

		sql_order = "RAND()"
		case @cur_sort
		when "random"
			sql_order = "RAND()"
		when "newest"
			sql_order = "created_at DESC"
		when "most_popular"
			sql_order = "num_supporter DESC"
		when "soon_ending"
			sql_order = "ended_at ASC"
		end

		sql_states = ""
		@states = params[:states]
		if (@states.nil? or @states.blank?) then
			sql_states = "state = #{Project.states[:funding_ext]}"
		else
			@states.split(',').each_with_index do |s, index|
				sql_states << ("state = #{s}")
				if index != @states.size - 1 then
					sql_states << " OR "
				end
			end
		end

		@projects = []

		if params[:genre] == 'All' then
			@projects = Project.where('(' + sql_states + ')').order(sql_order).paginate(:page => params[:page], :per_page => 12)
		else
			@projects = Project.where('(' + sql_states + ')').order(sql_order).tagged_with(@cur_genre).paginate(:page => params[:page], :per_page => 12)
		end
	end

	####################################################
	# search
	# search projects

	def search
		@sort = params[:sort] || "random"
		sql_order = "RAND()"
		case @sort
		when "random"
			sql_order = "RAND()"
		when "newest"
			sql_order = "created_at DESC"
		when "most_popular"
			sql_order = "num_supporter DESC"
		when "soon_ending"
			sql_order = "ended_at ASC"
		end

		sql_states = ""
		@states = params[:states]
		if (@states.nil? or @states.blank?) then
			sql_states = "state = #{Project.states[:funding_ext]}"
		else
			@states.split(',').each_with_index do |s, index|
				sql_states << ("state = #{s}")
				if index != @states.size - 1 then
					sql_states << " OR "
				end
			end
		end

		@genres = params[:genres]
		genre_tags = 'All'
		if (!@genres.nil? and !@genres.blank?) then
			genre_tags = params[:genres]
		end

		@projects = []

		if genre_tags == 'All' then
			@projects = Project.where('(' + sql_states + ')' + " AND " "name like ?", "%#{params[:name]}%").order(sql_order).paginate(:page => params[:page], :per_page => 12)
		else
			@projects = Project.where('(' + sql_states + ')' + " AND " "name like ?", "%#{params[:name]}%").order(sql_order).tagged_with(genre_tags).paginate(:page => params[:page], :per_page => 12)
		end
	end
end
