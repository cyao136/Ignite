class ProjectStateDefault < ActiveRecord::Migration
  def change
	change_column :projects, :state, :integer, default: 0
  end
end
