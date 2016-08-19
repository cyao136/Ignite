class AddReqCountToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :req_count, :integer, :default => 0
  end
end
