class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
	  t.belongs_to :user, index: true
	  
	  t.string :name
	  t.text :small_desc
	  t.text :full_desc
	  t.text :team_desc
	  t.text :creator_desc
	  t.integer :state
	  t.decimal :funding
	  
      t.timestamps null: false
    end
  end
end
