class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  def initialize_quests
    questArray = ["Comment","Project","Vote"].shuffle
    @quests = Quest.where(user_id: current_user.id)
    @quests.each do |quest|
      if questArray.include?(quest.name)
        questArray.delete(quest.name)
      end
    end
    while Quest.where(user_id: current_user.id).count < 3
      randQuest = questArray.pop
      create_quest(randQuest)
    end
  end

  def create_quest(randQuest)
    rand = random_quest(randQuest)
    @quest = Quest.build_from(current_user.id, rand[0], rand[1], rand[2], rand[3])
    @quest.save
  end

  def random_quest(randQuest)
    if randQuest == "Comment"
      name = "Comment"
      description = "Make a comment in a project's discussion page."
      state = "incomplete"
      exp = 20
    end
    if randQuest == "Project"
      name = "Project"
      description = "Check out a new project."
      state = "incomplete"
      exp = 10
    end
    if randQuest == "Vote"
      name = "Vote"
      description = "Vote on a comment in a project's discussion page."
      state = "incomplete"
      exp = 5
    end
    return name, description, state, exp
  end

  def delete_quests
    @quests = Quest.where(user_id: current_user.id)
    @quests.each do |quest|
      if quest.state == "awarded"
        quest.destroy
      end
    end
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
    delete_quests
    initialize_quests
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
