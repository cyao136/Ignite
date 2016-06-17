class Discussion < ActiveRecord::Base
	belongs_to :project

	acts_as_commentable

	enum topic: [
					:general,
					:bug,
					:suggestion
				]
end