class CreateImagesTable < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.timestamps
    end
    add_attachment :images, :image
  end
end
