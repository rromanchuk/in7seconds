class AddNotifcationColumns < ActiveRecord::Migration
  def change
    add_column :users, :email_opt_in, :boolean, :default => true
    add_column :users, :push_opt_in, :boolean, :default => true
  end
end
