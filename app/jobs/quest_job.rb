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

end
