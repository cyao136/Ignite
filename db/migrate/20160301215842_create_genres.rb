class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
	  t.belongs_to :project, index: true
	  
	  t.string :name
	  t.text :description

      t.timestamps null: false
    end
	
	create_table :genres_projects, id: false do |t|
	  t.belongs_to :genre, index: true
	  t.belongs_to :project, index: true
	end
  end
end
