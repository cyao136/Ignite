class Carrierwave < ActiveRecord::Migration
  def change
  	add_column  :videos, :asset, :string
  	add_column  :pictures, :asset, :string
  	add_column  :demos, :asset, :string
  end
end
