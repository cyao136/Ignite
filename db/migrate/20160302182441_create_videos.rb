class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
	  t.references :assetable, polymorphic: true, index: true
	  t.string :name

      t.timestamps null: false
    end
  end
end
