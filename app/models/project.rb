class ExternalLinkValidation < ActiveModel::Validator
  def validate(project)
    unless valid_kickstarter_link?(project.crowdfunding_link)
      project.errors[:crowdfunding_link] << 'Please enter a valid Kickstarter link!'
    end
  end
  def valid_kickstarter_link?(link)
	sub_url = /projects[^\?]++/.match(link).to_s
	slug = sub_url.split('/').last
	if slug == nil
		return false
	else
		client = Kickscraper.client
		kproj = client.find_project(slug)
		return !kproj.blank?
	end
  end
end

class Project < ActiveRecord::Base
	include ActiveModel::Validations
	include PublicActivity::Model
	belongs_to :user
	acts_as_taggable
	acts_as_commentable
	acts_as_readable :on => :created_at
	has_many :demos, :dependent => :destroy
	has_many :pledges
	has_many :videos, :dependent => :destroy
	has_many :pictures, as: :assetable, :dependent => :destroy
	accepts_nested_attributes_for :demos
	accepts_nested_attributes_for :pictures
	accepts_nested_attributes_for :videos

	# after a project is updated, check if new states needs to be changed
	after_save :evaluate!
  	

	enum state: [
					:unpublish,
					:funding,
					:archived,
					:deleted,
					:funding_ext,
					:ended
				]

	# Validations
	validates :user_id, presence: true
	validates :name, presence: true, length: { minimum: 4, maximum: 64 }
	validates :small_desc, length: { maximum: 150 }
	validates :full_desc, length: { maximum: 5000 }
	validates :creator_desc, length: { maximum: 1000 }

	with_options if: ->o {o.is_state? "unpublish"} do |v|
		v.validates :small_desc, presence: true, length: { minimum: 2 }
		v.validates :full_desc, presence: true, length: { minimum: 2 }
		v.validates :creator_desc, presence: true, length: { minimum: 2 }
		v.validates :creator_name, presence: true, length: { minimum: 2 }
	end

	with_options if: ->o {o.is_state? "funding_ext"} do |v|
		v.validates :crowdfunding_link, presence: true, length: { minimum: 2 }
		v.validates_with ExternalLinkValidation
	end

	def is_state?(s)
		self.state == s
	end

	def created?
		self.created_at != nil
	end

	# Project evaluations

	def evaluate!
		state = self.eval_state
		is_goal_reached = self.eval_goal

		update_columns(:state => state, :is_goal_reached => is_goal_reached)
	end

	def eval_state
		if self.ended_at <= DateTime.now then
			self.create_activity :ended
			return Project.states[:ended]
		else
			return self.state
		end
	end

	def eval_goal
		if (self.goal_supporter <= self.num_supporter) && (self.goal_funding <= self.funding) then
			self.create_activity :goal_reached
			return true
		else
			return false
		end
	end
end
