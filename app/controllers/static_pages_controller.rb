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
    # TODO: create function for staff/recommended picks
    @staff_picks = Project.all.order("num_supporter DESC").limit(3)
    
    @user_highscore_hash = Merit::Score.top_scored
    @activities = PublicActivity::Activity.where(trackable_type: "Comment").reverse_order.limit(8)

    # Have to make into an array for paginate to limit the number of projects
    recommended_projects = [] + Project.limit(30).order("num_supporter DESC")
    @projects = recommended_projects.paginate(:page => params[:page], :per_page => 6)
  end
end
