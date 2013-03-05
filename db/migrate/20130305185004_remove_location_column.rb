class RemoveLocationColumn < ActiveRecord::Migration
  def change
    remove_column :users, :location
    remove_column :users, :city
    remove_column :users, :country
  end
end
