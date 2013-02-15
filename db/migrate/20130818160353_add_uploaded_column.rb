class AddUploadedColumn < ActiveRecord::Migration
  def change
    add_column :images, :is_uploaded, :boolean
  end
end
