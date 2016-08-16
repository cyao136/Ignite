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
end
