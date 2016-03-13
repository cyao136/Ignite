class Video < ActiveRecord::Base
	belongs_to :asset, polymorphic: true
	has_attached_file :asset
	validates_attachment :asset, :presence => true,
		:content_type => { :content_type => "video/x-msvideo" },
		:size => { :in => 0..1000000.kilobytes }
end
