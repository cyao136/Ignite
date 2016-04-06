class DemosController < ApplicationController
	def new
		@demo = Demo.new
	end

	def create
		@demo = Demo.new(demo_params)
		if @demo.save
			flash[:success] = "The demo was added!"
		else
			flash[:danger] = @demo.errors.full_messages.to_sentence
		end
	end

	private

	def demo_params
		params.require(:demo).permit(:id, :project_id, :name, :version, :is_active, :asset)
	end
end