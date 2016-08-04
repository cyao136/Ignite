class Picture < ActiveRecord::Base
	belongs_to :assetable, polymorphic: true
	mount_uploader :asset, PictureUploader
	validate :picture_size_validation
	validates_presence_of :asset
  	
	acts_as_taggable
	
  	def to_jq_upload
		{
		  "url" => asset.medium.url,
		  "delete_url" => id,
		  "picture_id" => id,
		  "delete_type" => "DELETE"
		}.to_json
	end
	
	private
  
	def picture_size_validation
		errors[:asset] << "should be less than 5MB" if asset.size > 5.megabytes
	end
end
