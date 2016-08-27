module QuestsHelper

  def init_quest_array
    ["Comment","Project","Vote"].shuffle
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
        user.quests.create!(user_id: user.id, name: rand[0], description: rand[1], state: rand[2], exp: rand[3], req_count: rand[4])
        user.save
      end
    end
  end

  def initialize_quests_for_user(user)
    questArray = init_quest_array
    while user.quests.count < 3
      randQuest = questArray.pop
      rand = random_quest(randQuest)
      user.quests.create!(user_id: user.id, name: rand[0], description: rand[1], state: rand[2], exp: rand[3], req_count: rand[4])
      user.save
    end
  end

  def random_quest(randQuest)
    if randQuest == "Comment"
      name = "Comment"
      description = "Make a comment in a project's discussion page."
      state = "incomplete"
      exp = 20
      req_count = 1
    end
    if randQuest == "Project"
      name = "Project"
      description = "Check out a new project."
      state = "incomplete"
      exp = 10
      req_count = 1
    end
    if randQuest == "Vote"
      name = "Vote"
      description = "Vote on a comment in a project's discussion page."
      state = "incomplete"
      exp = 5
      req_count = 1
    end
    return name, description, state, exp, req_count
  end

  def delete_quests
    @quests = Quest.where(state: "awarded")
    @quests.each do |quest|
      quest.destroy
    end
  end
end
