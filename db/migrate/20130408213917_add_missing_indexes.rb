class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :users, :is_active
    add_index :users, :gender
    add_index :users, :looking_for_gender
  end

  def down
  end
end
