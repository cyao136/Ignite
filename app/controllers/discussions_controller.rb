class DiscussionsController < ApplicationController
	def new
		@discussion = Discussion.new
	end

	def create
		@discussion = Discussion.new(discussion_params)
		if not @discussion.save
			flash[:danger] = @discussion.errors.full_messages.to_sentence
		end
	end

	def show

	end

	def write_comment

	end

	private

	def discussion_params
		params.require(:discussion).permit(:topic)
	end
end
