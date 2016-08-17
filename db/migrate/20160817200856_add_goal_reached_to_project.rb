class AddGoalReachedToProject < ActiveRecord::Migration
  def change
    add_column :projects, :goal_supporter, :integer, :default => 0
    add_column :projects, :goal_funding, :decimal, :default => 0
    add_column :projects, :is_goal_reached, :boolean
  end
end
