class Demo < ActiveRecord::Base
	belongs_to :project
	has_attached_file :asset
	validates_attachment :asset, :presence => true,
		:content_type => { :content_type => "application/x-msdownload" }
		
	validates :project_id, presence: true
end
