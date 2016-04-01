class DropNewPicturesTable < ActiveRecord::Migration
  def up
    drop_table :new_pictures
  end

  def down
    create_table :new_pictures
  end
end
