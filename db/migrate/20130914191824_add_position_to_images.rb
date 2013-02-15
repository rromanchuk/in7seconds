class AddPositionToImages < ActiveRecord::Migration
  def change
    add_column :images, :profile_position, :integer, :length => 1
  end
end
