class AddDefaultValueToUploaded < ActiveRecord::Migration
  def change
    Image.all.each do |i|
      i.is_uploaded = false;
      i.save
    end
    change_column :images, :is_uploaded, :boolean, :default => false
  end
end
