class CreateDemos < ActiveRecord::Migration
  def change
    create_table :demos do |t|
	  t.belongs_to :project, index: true
	  
	  t.string :name
	  t.string :reference
	  t.string :version
	  t.boolean :is_active
	  
      t.timestamps null: false
    end
  end
end
