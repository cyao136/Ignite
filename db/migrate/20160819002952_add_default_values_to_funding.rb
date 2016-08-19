class AddDefaultValuesToFunding < ActiveRecord::Migration
  def change
    change_column :projects, :funding, :decimal, :default => 0
  end
end
