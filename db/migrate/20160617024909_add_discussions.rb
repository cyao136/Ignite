class AddDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
	  t.belongs_to :project, index: true
	  t.integer :topic,   default: 0

      t.timestamps null: false
    end
  end
end
