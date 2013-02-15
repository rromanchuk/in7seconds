class AddNumRequestsColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :num_requests, :integer
    add_index :users, :num_requests
  end
end
