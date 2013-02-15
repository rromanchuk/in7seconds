class CreateFbLocationsTable < ActiveRecord::Migration
  def up
    create_table :fb_locations do |t|
      t.string :name 
      t.column :lid, :bigint
    end
    add_index :fb_locations, :lid
  end
end
