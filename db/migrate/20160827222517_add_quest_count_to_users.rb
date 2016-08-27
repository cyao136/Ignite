class AddQuestCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :quest_count, :integer, :default => 0
  end
end
