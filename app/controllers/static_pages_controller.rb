class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!
  def home
  end

  def about
  end
end
