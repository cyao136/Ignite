class FixAttachmentToPictures < ActiveRecord::Migration
  def self.down
    remove_attachment :pictures, :asset
  end
end
