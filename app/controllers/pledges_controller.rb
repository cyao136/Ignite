class PledgesController < ApplicationController
	def new
		@pledge = Pledge.new
	end

	def create
		@pledge = Pledge.new(pledge_params)
		if @pledge.save
			flash[:success] = "The pledge was added!"
		else
			flash[:danger] = @pledge.errors.full_messages.to_sentence
		end
	end

	private

	def pledge_params
		params.require(:pledge).permit(:id, :project_id, :name, :description, :max_number, :is_active, :cost)
	end
end
