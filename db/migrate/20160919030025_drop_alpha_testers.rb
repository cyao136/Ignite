class DropAlphaTesters < ActiveRecord::Migration
  def change
    drop_table 'alpha_testers' if ActiveRecord::Base.connection.table_exists? 'alpha_testers'
  end
end
