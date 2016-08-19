class Quest < ActiveRecord::Base
  belongs_to :user

  enum state: [
    :incomplete,
    :completed,
    :awarded
      ]

  validates :user_id, presence: true
  validates :name, presence: true
  validates :exp, presence: true

  def complete_quest
    if self.state == "incomplete"
      update_attribute(:state, "completed")
      award_points
    end
  end

  def award_points
    @user = User.find(self.user_id)
    @user.add_points(self.exp)
    update_attribute(:state, "awarded")
  end

  def evaluate(activity)
    if self.state == "incomplete"
      if self.name == "Comment" and activity.key == "comment.create"
        eval_comment(activity)
      elsif self.name == "Vote" and (activity.key == "comment.upvote" or activity.key == "comment.downvote")
        self.complete_quest
      elsif self.name == "Project" and activity.key == "project.read_by_user"
        self.complete_quest
      end
    end
  end

  private

  def eval_comment(activity)
    user_id = self.user_id
    progress = PublicActivity::Activity.where("activities.key = \'#{activity.key}\' AND owner_type = 'User' AND owner_id = #{user_id} AND created_at >= \'#{self.created_at.to_s(:db)}\'").count
    if progress >= self.req_count
      self.complete_quest
    end
  end
end
