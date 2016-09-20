class RemoveApprovedToUser < ActiveRecord::Migration
  def change
    remove_index  :users, :approved
    remove_column :users, :approved
  end
end
