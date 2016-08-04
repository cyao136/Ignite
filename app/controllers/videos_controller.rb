class VideosController < ApplicationController
	def new
		@video = Video.new
	end

	def create
		@video = Video.new(video_params)
		@video.save

	end

	private

	def video_params
		params.require(:video).permit(:name, :description, :web_id, :host, :tag_list, :embed_link, :thumbnail_link, :project_id)
	end
end