class Picture < ActiveRecord::Base
	belongs_to :asset, polymorphic: true
	has_attached_file :asset
	validates_attachment :asset, :presence => true,
		:content_type => { :content_type => "image/jpg" },
		:size => { :in => 0..5000.kilobytes }
end
