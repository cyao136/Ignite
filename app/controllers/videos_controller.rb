class VideosController < ApplicationController
	def new
		@video = Video.new
	end

	def create
		@video = Video.create(asset: params[:asset])
		if @video.save
		    respond_to do |format|
		      format.html { render json: @video.to_jq_upload, content_type: 'text/html', layout: false }
		      format.json { render json: @video.to_jq_upload }
		    end
		else
		    render json: { error: @video.errors.full_messages }, status: 304
		end
	end

	private

	def video_params
		params.require(:video).permit(:name, :assetable_id, :assetable_type, :asset)
	end
end