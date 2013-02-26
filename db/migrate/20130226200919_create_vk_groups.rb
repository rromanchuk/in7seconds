class CreateVkGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
     t.integer :gid
     t.string :name
     t.string :photo
     t.string :provider
    end
    add_index :groups, :gid
    add_index :groups, :provider
  end

end
