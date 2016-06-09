class Video < ActiveRecord::Base
	belongs_to :assetable, polymorphic: true
	mount_uploader :asset, VideoUploader
	validate :video_size_validation
	validates_presence_of :asset
  
  	def to_jq_upload
		{
		  "url" => asset.medium.url,
		  "delete_url" => id,
		  "picture_id" => id,
		  "delete_type" => "DELETE"
		}.to_json
	end
	
	private
  
	def video_size_validation
		errors[:asset] << "should be less than 1GB" if asset.size > 1.gigabyte
	end
end
