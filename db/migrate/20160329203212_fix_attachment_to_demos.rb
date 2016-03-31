class FixAttachmentToDemos < ActiveRecord::Migration
  def self.down
    remove_attachment :demos, :asset
  end
end
