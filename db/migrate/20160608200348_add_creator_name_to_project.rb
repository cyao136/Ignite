class AddCreatorNameToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :creator_name, :string
  end
end
