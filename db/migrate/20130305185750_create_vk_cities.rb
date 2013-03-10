class CreateVkCities < ActiveRecord::Migration
  def change
    create_table :vk_cities do |t|
      t.string :name
      t.integer :cid
    end

    create_table :vk_countries do |t|
      t.string :name
      t.integer :cid
    end
    add_index :vk_cities, :cid
    add_index :vk_countries, :cid
  end
end
