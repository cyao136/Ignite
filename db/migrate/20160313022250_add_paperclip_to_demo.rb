class AddPaperclipToDemo < ActiveRecord::Migration
  def change
	add_attachment :demos, :asset
  end
end
