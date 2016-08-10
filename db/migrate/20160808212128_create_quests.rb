class CreateQuests < ActiveRecord::Migration
  def change
    create_table :quests do |t|
    t.belongs_to :user, index: true

    t.string :name
    t.text :description
    t.integer :state,   default: 0
    t.integer :exp

      t.timestamps null: false
    end
  end
end
