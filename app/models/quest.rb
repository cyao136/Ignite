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

  def self.build_from(user_id, name, description, state, exp)
    new \
      :user_id     => user_id,
      :name        => name,
      :description => description,
      :state       => state,
      :exp         => exp
  end

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
