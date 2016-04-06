class Video < ActiveRecord::Base
	belongs_to :assetable, polymorphic: true
	mount_uploader :asset, VideoUploader
	validate :video_size_validation
	validates_presence_of :asset
  
	private
  
	def video_size_validation
		errors[:asset] << "should be less than 1GB" if asset.size > 1.gigabyte
	end
end
