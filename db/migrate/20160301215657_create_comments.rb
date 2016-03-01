class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
	  t.references :commentable, polymorphic: true, index: true
	  
	  t.text :text
	  t.integer :type
	  t.integer :like

      t.timestamps null: false
    end
  end
end
