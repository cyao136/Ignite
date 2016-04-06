class Demo < ActiveRecord::Base
	belongs_to :project
	mount_uploader :asset, DemoUploader
		
	validates :project_id, presence: true
	validates_presence_of :asset
end
