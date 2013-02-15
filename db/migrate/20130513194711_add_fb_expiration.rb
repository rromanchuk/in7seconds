class AddFbExpiration < ActiveRecord::Migration
  def change
    add_column :users, :fb_token_expiration, :datetime
  end
end
