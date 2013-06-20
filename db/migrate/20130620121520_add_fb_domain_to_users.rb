class AddFbDomainToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_domain, :string
  end
end
