class AddThreads < ActiveRecord::Migration
  def change
    create_table :threads do |t|
	  t.integer :type,   default: 0

      t.timestamps null: false
    end
  end
end
