class AddBelongsToOnUsers < ActiveRecord::Migration
  def change
    add_column :users, :vk_country_id, :integer
    add_column :users, :vk_city_id, :integer

    add_index :users, :vk_country_id
    add_index :users, :vk_city_id

    remove_column :users, :country_id
    remove_column :users, :city_id
    remove_column :users, :vk_city
    remove_column :users, :vk_country
  end
end
