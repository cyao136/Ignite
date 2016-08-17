class AddDailyLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :daily_login, :integer, default: 0
  end
end
