class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!
  def home
  end

  def about
  end

  def countdown
    render :layout => "countdown"
  end
end
