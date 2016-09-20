class StaticPagesController < ApplicationController
  #edited for alpha stage
  skip_before_filter :authenticate_user!, only: [:redirect]
  def home
  end

  def about
  end

  def main
    # TODO: create function for staff/recommended picks
    @staff_picks = Project.where(state: 4).order("num_supporter DESC").limit(3)
    
    @user_highscore_hash = Merit::Score.top_scored
    @activities = PublicActivity::Activity.where(trackable_type: "Comment").reverse_order.limit(8)

    # Have to make into an array for paginate to limit the number of projects
    recommended_projects = [] + Project.where(state: 4).limit(30).order("num_supporter DESC")
    @projects = recommended_projects.paginate(:page => params[:page], :per_page => 6)
  end

  def redirect
    redirect_to '/main'
  end
end
