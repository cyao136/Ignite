class FixAttachmentToVideos < ActiveRecord::Migration
  def self.down
    remove_attachment :videos, :asset
  end
end
