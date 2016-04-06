class Picture < ActiveRecord::Base
	belongs_to :assetable, polymorphic: true
	mount_uploader :asset, PictureUploader
	validate :picture_size_validation
	validates_presence_of :asset
  
	private
  
	def picture_size_validation
		errors[:asset] << "should be less than 5MB" if asset.size > 5.megabytes
	end
end
