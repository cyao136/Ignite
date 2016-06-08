class AddExtLinkToProject < ActiveRecord::Migration
  def change
  	add_column  :projects, :crowdfunding_link, :string
  	add_column  :projects, :facebook_link, :string
  	add_column  :projects, :twitter_link, :string
  	add_column  :projects, :website_link, :string
  	
  	add_column  :projects, :youtube_link, :string
  end
end
