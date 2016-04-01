class Picture < ActiveRecord::Base
	belongs_to :assetable, polymorphic: true
	has_attached_file :asset, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :asset, content_type: /\Aimage\/.*\Z/
end
