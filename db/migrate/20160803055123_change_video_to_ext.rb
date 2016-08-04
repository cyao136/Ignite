class ChangeVideoToExt < ActiveRecord::Migration
  def change
    drop_table :videos

    create_table :videos do |t|
      t.belongs_to :project, index: true
  	  t.string :web_id
  	  t.text :description
      t.string :name
  	  t.string :host
  	  t.string :embed_link
  	  t.string :thumbnail_link

      t.timestamps null: false
    end
  end
end
