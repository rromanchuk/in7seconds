class AddVkUserColumns < ActiveRecord::Migration
  def change
    add_column :users, :vk_domain, :string
    add_column :users, :vk_university_name, :string
    add_column :users, :vk_faculty_name, :string
    add_column :users, :vk_mobile_phone, :string
    add_column :users, :vk_graduation, :string
    add_column :users, :vk_city, :integer
    add_column :users, :vk_country, :integer
  end
end
