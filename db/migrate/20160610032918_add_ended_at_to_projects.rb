class AddEndedAtToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :ended_at, :datetime
  end
end
