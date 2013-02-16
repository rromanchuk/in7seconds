class AddLookingForColumn < ActiveRecord::Migration
  def change
    add_column :users, :looking_for_gender, :integer
  end
end
