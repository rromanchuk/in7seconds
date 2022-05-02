class AddIndexOnDistance < ActiveRecord::Migration
  def change
    add_index :users, [:latitude, :longitude]
  end
end
