class AddColumntoUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_location_id, :integer
    add_index :users, :fb_location_id
  end
end
