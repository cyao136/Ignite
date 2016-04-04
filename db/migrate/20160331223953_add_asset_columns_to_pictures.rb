class AddAssetColumnsToPictures < ActiveRecord::Migration
  def up
    add_attachment :pictures, :asset
  end

  def down
    remove_attachment :pictures, :asset
  end
end
