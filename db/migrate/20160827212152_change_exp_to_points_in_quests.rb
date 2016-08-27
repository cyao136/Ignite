class ChangeExpToPointsInQuests < ActiveRecord::Migration
  def change
    rename_column :quests, :exp, :points
  end
end
