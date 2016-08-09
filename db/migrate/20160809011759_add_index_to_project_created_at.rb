class AddIndexToProjectCreatedAt < ActiveRecord::Migration
  def change
    add_index :projects, :created_at
  end
end
