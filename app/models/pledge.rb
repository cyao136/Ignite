class Pledge < ActiveRecord::Base
	belongs_to :project
	has_and_belongs_to_many :users
	# Validations
	validates :project_id, presence: true
	validates :name, presence: true, length: { minimum: 4, maximum: 32 }
	validates :description, presence: true, length: { minimum: 4, maximum: 150 }
	validates :cost, presence: true, numericality: { greater_than_or_equal_to: 1 }
	validates :max_number, numericality: { greater_than_or_equal_to: 1 }, if: :max_is_not_blank

	def max_is_not_blank
		!(max_number.blank?)
	end
end
