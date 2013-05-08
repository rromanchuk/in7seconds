class AddTokenExpirationColumns < ActiveRecord::Migration
  def change
    add_column :users, :vk_token_expiration, :datetime
  end
end
