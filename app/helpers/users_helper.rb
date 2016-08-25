module UsersHelper
	def check_daily_login
		if (current_user.current_sign_in_at.to_date - current_user.last_sign_in_at.to_date) >= 1
			if current_user.daily_login == "zero"
				current_user.update_attribute(:daily_login, "one")
			end
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
end
