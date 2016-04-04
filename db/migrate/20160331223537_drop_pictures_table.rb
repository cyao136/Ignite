class DropPicturesTable < ActiveRecord::Migration
  def up
    drop_table :pictures
  end

  def down
    create_table :pictures
  end
end
