class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
	  t.belongs_to :project, index: true

	  t.decimal :goal_value
	  t.decimal :cur_value
	  t.boolean :goal_overflowable
	  t.boolean :goal_is_met
	  t.boolean :is_monetary
	  t.boolean :is_active
	  t.integer :activating_state
	  
      t.timestamps null: false
    end
  end
end
