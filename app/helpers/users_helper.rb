module UsersHelper
	def check_daily_login
		if (current_user.current_sign_in_at.to_date - current_user.last_sign_in_at.to_date) >= 1
			if current_user.daily_login == "zero"
				current_user.update_attribute(:daily_login, "one")
			end
		end
	end
end
