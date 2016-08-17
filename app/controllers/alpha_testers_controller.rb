class AlphaTestersController < ApplicationController
  skip_before_filter :authenticate_user!

  def new
    @alpha_tester = AlphaTester.new
  end

  def create
    @alpha_tester = AlphaTester.new(email: params[:alpha_tester][:email])
    p params
    respond_to do |format|
      if @alpha_tester.save
      format.html  { redirect_to(:back, :notice => 'Thanks!') }
      else
      format.html  { redirect_to(:back, :notice => 'Failed.') }
      end
    end
  end

  private

  def alpha_tester_params
    params.require(:alpha_tester).permit(:email)
  end
end
