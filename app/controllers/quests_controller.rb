class QuestsController < ApplicationController

  def show
    @quest = Quest.find(params[:id])
  end

  private

  def quest_params
    params.require(:quest).permit(:id, :name, :description, :state, :exp)
  end


end
