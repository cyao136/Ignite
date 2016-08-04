class Video < ActiveRecord::Base
	belongs_to :project
	acts_as_taggable
end
