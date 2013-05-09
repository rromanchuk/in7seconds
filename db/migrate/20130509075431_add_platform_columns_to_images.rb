class AddPlatformColumnsToImages < ActiveRecord::Migration
  def change
    add_column :images, :provider, :string
    add_column :images, :external_id, :bigint
    add_index :images, :external_id
  end
end
