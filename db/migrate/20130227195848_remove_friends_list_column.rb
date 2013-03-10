class RemoveFriendsListColumn < ActiveRecord::Migration
  def change
    remove_column :users, :friends_list
  end
end
