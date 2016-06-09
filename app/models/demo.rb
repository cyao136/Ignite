class Demo < ActiveRecord::Base
	belongs_to :project
	mount_uploader :asset, DemoUploader
	validates :project_id, presence: true
	validates_presence_of :asset
	
  	def to_jq_upload
		{
		  "url" => asset.medium.url,
		  "delete_url" => id,
		  "picture_id" => id,
		  "delete_type" => "DELETE"
		}.to_json
	end
end
