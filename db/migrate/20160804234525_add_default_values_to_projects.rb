class AddDefaultValuesToProjects < ActiveRecord::Migration
  def change
  	change_column :projects, :num_supporter, :integer, :default => 0
  	change_column :projects, :ended_at, :datetime, :default => DateTime.civil(9999)
  end
end
