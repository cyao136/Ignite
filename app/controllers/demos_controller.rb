class DemosController < ApplicationController
	def new
		@demo = Demo.new
	end

	def create
		@demo = Demo.create(asset: params[:asset])
		if @demo.save
		    respond_to do |format|
		      format.html { render json: @demo.to_jq_upload, content_type: 'text/html', layout: false }
		      format.json { render json: @demo.to_jq_upload }
		    end
		else
		    render json: { error: @demo.errors.full_messages }, status: 304
		end
	end

	private

	def demo_params
		params.require(:demo).permit(:id, :project_id, :name, :version, :is_active, :asset)
	end
end