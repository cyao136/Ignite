class RenameImageableInPictures < ActiveRecord::Migration
  def self.up
    rename_column :pictures, :imageable_id, :assetable_id
	rename_column :pictures, :imageable_type, :assetable_type
  end

  def self.down
    rename_column :pictures, :assetable_id, :imageable_id
	rename_column :pictures, :assetable_type, :imageable_type
  end
end
