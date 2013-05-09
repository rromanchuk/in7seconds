class AddRemoteUrlToImages < ActiveRecord::Migration
  def change
    add_column :images, :remote_url, :string
  end
end
