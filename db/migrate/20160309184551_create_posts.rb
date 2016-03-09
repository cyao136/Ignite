class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
	  t.belongs_to :project, index: true
	  t.belongs_to :user, index: true
	  
	  t.integer :type
	  t.text :message
	  
      t.timestamps null: false
    end
  end
end
