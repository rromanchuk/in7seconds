class CreateFriendships < ActiveRecord::Migration
 def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friendship_id
      t.timestamps
    end
    add_index :friendships, :user_id
    add_index :friendships, :friendship_id
    add_index :friendships, [:user_id, :friendship_id], unique: true
  end
end
