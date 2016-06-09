class RemoveGenres < ActiveRecord::Migration
  def change
    drop_table :genres
    drop_table :genres_projects
  end
end
