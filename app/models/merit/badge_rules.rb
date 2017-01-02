# Be sure to restart your server when you modify this file.
#
# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean (recieves the object as parameter)
# * A block with a hash composed of methods to run on the target object with
#   expected values (+votes: 5+ for instance).
#
# +grant_on+ can have a +:to+ method name, which called over the target object
# should retrieve the object to badge (could be +:user+, +:self+, +:follower+,
# etc). If it's not defined merit will apply the badge to the user who
# triggered the action (:action_user by default). If it's :itself, it badges
# the created object (new user for instance).
#
# The :temporary option indicates that if the condition doesn't hold but the
# badge is granted, then it's removed. It's false by default (badges are kept
# forever).

module Merit
  class BadgeRules
    include Merit::BadgeRulesMethods

    def initialize
      # If it creates user, grant badge
      # Should be "current_user" after registration for badge to be granted.
      # Find badge by badge_id, badge_id takes presidence over badge
      # grant_on 'users#create', badge_id: 7, badge: 'just-registered', to: :itself

      # If it has 10 comments, grant commenter-10 badge
      # grant_on 'comments#create', badge: 'commenter', level: 10 do |comment|
      #   comment.user.comments.count == 10
      # end

      # If it has 5 votes, grant relevant-commenter badge
      # grant_on 'comments#vote', badge: 'relevant-commenter',
      #   to: :user do |comment|
      #
      #   comment.votes.count == 5
      # end

      # Changes his name by one wider than 4 chars (arbitrary ruby code case)
      # grant_on 'registrations#update', badge: 'autobiographer',
      #   temporary: true, model_name: 'User' do |user|
      #
      #   user.name.length > 4
      # end

      grant_on 'comments#upvote',  badge_id: 1, model_name: 'User' do |f|
        if User.current
          (1..9).include?((User.find(User.current.id).get_voted Comment).count)
        end
      end

      grant_on 'comments#upvote',  badge_id: 2, model_name: 'User' do |f|
        if User.current
          (10..99).include?((User.find(User.current.id).get_voted Comment).count)
        end
      end

      grant_on 'comments#upvote',  badge_id: 3, model_name: 'User' do |f|
        if User.current
          (User.find(User.current.id).get_voted Comment).count >= 100
        end
      end

      grant_on 'comments#create',  badge_id: 4, model_name: 'User' do |f|
        if User.current
          (1..9).include?(Comment.where(user_id: User.current.id).count)
        end
      end

      grant_on 'comments#create',  badge_id: 5, model_name: 'User' do |f|
        if User.current
          (10..99).include?(Comment.where(user_id: User.current.id).count)
        end
      end

      grant_on 'comments#create',  badge_id: 6, model_name: 'User' do |f|
        if User.current
          Comment.where(user_id: User.current.id).count >= 100
        end
      end

      grant_on 'projects#show',  badge_id: 7, model_name: 'User' do |f|
        if User.current
          (1..9).include?(Project.all.read_by(User.current).count)
        end
      end

      grant_on 'projects#show',  badge_id: 8, model_name: 'User' do |f|
        if User.current
          (10..99).include?(Project.all.read_by(User.current).count)
        end
      end

      grant_on 'projects#show',  badge_id: 9, model_name: 'User' do |f|
        if User.current
          Project.all.read_by(User.current).count >= 100
        end
      end

      grant_on 'projects#upvote',  badge_id: 10, model_name: 'User' do |f|
        if User.current
          (1..9).include?((User.find(User.current.id).get_voted Project).count)
        end
      end

      grant_on 'projects#upvote',  badge_id: 11, model_name: 'User' do |f|
        if User.current
          (10..99).include?((User.find(User.current.id).get_voted Project).count)
        end
      end

      grant_on 'projects#upvote',  badge_id: 12, model_name: 'User' do |f|
        if User.current
          (User.find(User.current.id).get_voted Project).count >= 100
        end
      end

      grant_on 'users/sessions#create',  badge_id: 13, model_name: 'User' do |f|
        if User.current
          (3..6).include?(User.find(User.current.id)[:daily_login])
        end
      end

      grant_on 'users/sessions#create',  badge_id: 14, model_name: 'User' do |f|
        if User.current
          (7..29).include?(User.find(User.current.id)[:daily_login])
        end
      end

      grant_on 'users/sessions#create',  badge_id: 15, model_name: 'User' do |f|
        if User.current
          User.find(User.current.id)[:daily_login] >= 30
        end
      end

      grant_on 'quests#award_points',  badge_id: 16, model_name: 'User' do |f|
        if User.current
          (100..499).include?(User.find(User.current.id).points)
        end
      end

      grant_on 'quests#award_points',  badge_id: 17, model_name: 'User' do |f|
        if User.current
          (500..999).include?(User.find(User.current.id).points)
        end
      end

      grant_on 'quests#award_points',  badge_id: 18, model_name: 'User' do |f|
        if User.current
          User.find(User.current.id).points >= 1000
        end
      end

      grant_on 'users#incr_quest_count',  badge_id: 19, model_name: 'User' do |f|
        if User.current
          (1..9).include?(User.find(User.current.id).quest_count)
        end
      end

      grant_on 'users#incr_quest_count',  badge_id: 20, model_name: 'User' do |f|
        if User.current
          (10..99).include?(User.find(User.current.id).quest_count)
        end
      end

      grant_on 'users#incr_quest_count',  badge_id: 21, model_name: 'User' do |f|
        if User.current
          User.find(User.current.id).quest_count >= 100
        end
      end

    end
  end
end
