class AddPaperclipToPicture < ActiveRecord::Migration
  def change
	add_attachment :pictures, :asset
  end
end
