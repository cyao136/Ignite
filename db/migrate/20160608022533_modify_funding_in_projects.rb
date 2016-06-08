class ModifyFundingInProjects < ActiveRecord::Migration
  def change
  	add_column  :projects, :num_supporter, :integer
  end
end
