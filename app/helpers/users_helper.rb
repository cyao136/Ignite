module UsersHelper
	def check_daily_login
		if (current_user.current_sign_in_at.to_date - current_user.last_sign_in_at.to_date) == 1
			if current_user[:daily_login] < 5
				current_user[:daily_login] += 5
        current_user.save!
        #broadcast("/users/<%= current_user.id %>/quest_complete", {title: "Daily Login", msg: "You logged in #{current_user[:daily_login].to_s} days in a row!"})
			elsif current_user[:daily_login] == 5
        #broadcast("/users/<%= current_user.id %>/quest_complete", {title: "Daily Login", msg: "You logged in 5 or more days in a row!"})
      end
    elsif (current_user.current_sign_in_at.to_date - current_user.last_sign_in_at.to_date) > 1
      current_user[:daily_login] = 0
      current_user.save!
      #broadcast("/users/<%= current_user.id %>/quest_complete", {title: "rip in balls", msg: "riripripriprpirpiripri!"})
		end
	end

  def show_join_date
    current_user.created_at.strftime("%b %d, %Y")
  end

  def current_level
    (current_user.points)/100
  end

  def current_level_progress
    (current_user.points)%100
  end

  def quest_state_for_card(quest)
    if quest.state == "incomplete"
      "border-color: blue;"
    elsif quest.state == "awarded"
      "border-color: green;"
    end
  end

  def quest_state_for_tooltip(quest)
    if quest.state == "incomplete"
      "In Progress..."
    elsif quest.state == "awarded"
      "Complete!"
    end
  end

  def is_logged_in_user?
    current_user.id == User.find(params[:id]).id
  end
end
