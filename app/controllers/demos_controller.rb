class DemosController < ApplicationController
	def new
		@demo = Demo.new
	end

	def create
		@demo = Demo.new(demo_params)
		@demo.project_id = params[:project_id]
		if @demo.save
			flash[:success] = "The demo was added!"
			render 'projects/demo_upload'
		else
			flash[:danger] = @demo.errors.full_messages.to_sentence
			render 'projects/demo_upload'
		end
	end

	private

	def demo_params
		params.require(:demo).permit(:name, :version, :asset)
	end
end