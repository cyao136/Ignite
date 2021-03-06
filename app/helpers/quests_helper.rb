module QuestsHelper

  def init_quest_array
    ["Comment","Project","Vote","Like a project"].shuffle
  end

  def initialize_quests_for_user(user)
    questArray = init_quest_array
    while user.quests.count < 3
      randQuest = questArray.pop
      rand = random_quest(randQuest)
      user.quests.create!(user_id: user.id, name: rand[0], description: rand[1], state: rand[2], points: rand[3], req_count: rand[4])
      user.save!
    end
  end

  def random_quest(randQuest)
    if randQuest == "Comment"
      name = "Comment"
      description = "Make a comment in a project's discussion page."
      state = "incomplete"
      points = 20
      req_count = 1
    end
    if randQuest == "Project"
      name = "Project"
      description = "Check out a new project."
      state = "incomplete"
      points = 10
      req_count = 1
    end
    if randQuest == "Vote"
      name = "Vote"
      description = "Vote on a comment in a project's discussion page."
      state = "incomplete"
      points = 5
      req_count = 1
    end
    if randQuest == "Like a project"
      name = "Like a project"
      description = "Like a project."
      state = "incomplete"
      points = 10
      req_count = 1
    end
    return name, description, state, points, req_count
  end

end
