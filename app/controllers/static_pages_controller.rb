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
end
