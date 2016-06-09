class RemoveTeamDesc < ActiveRecord::Migration
  def change
  	remove_column  :projects, :team_desc
  end
end
