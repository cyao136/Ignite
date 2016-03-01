class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
	  t.references :storeable, polymorphic: true, index: true
	  
	  t.string :name
	  t.string :reference_link
      
	  t.timestamps null: false
    end
  end
end
