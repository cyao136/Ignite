class QuestJob
  include QuestsHelper

  def reset_quests()
    delete_quests
    initialize_quests
  end
  handle_asynchronously :reset_quests, :queue => "quest"
  def self.runner
    quest_job = QuestJob.new
    quest_job.reset_quests
  end

  def initialize_quests
    @users = User.all
    @users.each do |user|
      @quests = user.quests
      questArray = init_quest_array
      @quests.each do |quest|
        if questArray.include?(quest.name)
          questArray.delete(quest.name)
        end
      end
      while user.quests.count < 3
        randQuest = questArray.pop
        rand = random_quest(randQuest)
        user.quests.create!(user_id: user.id, name: rand[0], description: rand[1], state: rand[2], points: rand[3], req_count: rand[4])
        user.save
      end
    end
  end

  def delete_quests
    @quests = Quest.where(state: 2)
    @quests.each do |quest|
      quest.destroy
    end
  end
end
