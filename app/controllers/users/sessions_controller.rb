class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]
#



    def initialize_quests
    p "test"
    if Quest.where(user_id: current_user.id).count < 1
      create_quest
    end
    end

    def create_quest
    p "quest test"
    rand = random_quest
    @quest = Quest.build_from(current_user.id, rand[0], rand[1], rand[2])
    @quest.save
    end

    def random_quest
    num = rand(3)
    if num == 0 or num == 1 or num == 2
      name = "test"
      state = "incomplete"
      exp = 10
    end
    return name, state, exp
    end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
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
