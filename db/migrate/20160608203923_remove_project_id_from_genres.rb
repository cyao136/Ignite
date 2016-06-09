class RemoveProjectIdFromGenres < ActiveRecord::Migration
  def change
  	remove_index :genres, :project_id
  end
end
