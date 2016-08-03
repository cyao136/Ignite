class AddVideoLinksToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :video_links, :text
  end
end
