class StaticPagesController < ApplicationController
  #edited for alpha stage
  skip_before_filter :authenticate_user!, only: [:countdown]
  layout "countdown", only: [:countdown]
  def home
  end

  def about
  end

  def countdown
    @alpha_tester = AlphaTester.new
  end

  def main
    @staff_picks = Project.where(id: 8..10)
    @user_highscore_hash = Merit::Score.top_scored
    @activities = PublicActivity::Activity.where(trackable_type: "Comment")
  end
end
