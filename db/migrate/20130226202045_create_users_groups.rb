class CreateUsersGroups < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :group_id
      t.timestamps
    end
    add_index :memberships, [:user_id, :group_id], unique: true
  end
end
