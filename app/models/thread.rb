class Thread < ActiveRecord::Base
	belongs_to :project

	acts_as_commentable

	enum type: [
					:general,
					:bugs,
					:suggestion
				]
end