class VideosController < ApplicationController
	def new
		@video = Video.new
	end

	def create
		@video = Video.new(video_params)
		if @video.save
			flash[:success] = "The video was added!"
		else
			flash[:danger] = @video.errors.full_messages.to_sentence
		end
	end

	private

	def video_params
		params.require(:video).permit(:name, :assetable_id, :assetable_type, :asset)
	end
end