class PicturesController < ApplicationController
	def new
		@picture = Picture.new
	end

	def create
		params[:assets].each{ |asset|
		@picture = Picture.create(asset: asset)
		  if @picture.save
		    respond_to do |format|
		      format.html { render json: @picture.to_jq_upload, content_type: 'text/html', layout: false }
		      format.json { render json: @picture.to_jq_upload }
		    end
		  else
		    render json: { error: @picture.errors.full_messages }, status: 304
		  end
		}
	end
	
	private

	def picture_params
		params.require(:picture).permit(:name, :assetable_id, :tag_list, :assetable_type, :asset)
	end
end