class PicturesController < ApplicationController
	def new
		@picture = Picture.new
	end

	def create
		@picture = Picture.new(picture_params)
		if @picture.save
			flash[:success] = "The picture was added!"
			redirect_to user_path(current_user)
		else
			flash[:danger] = @picture.errors.full_messages.to_sentence
			redirect_to user_path(current_user)
		end
	end

	private

	def picture_params
		params.require(:picture).permit(:name, :assetable_id, :assetable_type, :asset)
	end
end