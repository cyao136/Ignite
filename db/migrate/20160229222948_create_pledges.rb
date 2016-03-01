class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
	  t.belongs_to :project, index: true
	  
	  t.string :name
	  t.text :description
	  t.decimal :cost
	  t.integer :max_number
	  t.boolean :is_active
	  
      t.timestamps null: false
    end
	
	create_table :pledges_users, id: false do |t|
	  t.belongs_to :pledge, index: true
	  t.belongs_to :user, index: true
	end
  end
end
