class AddThreddedValueToUsers < ActiveRecord::Migration
  def change
  	DbTextSearch::CaseInsensitive.add_index(
    connection, Thredded.user_class.table_name, Thredded.user_name_column, unique: true)
    add_column :users, :admin, :boolean, default: false
  end
end
