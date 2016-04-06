class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.references :assetable, polymorphic: true, index: true
      t.timestamps null: false
      
    end
  end
end