class AddMessageColumns < ActiveRecord::Migration
  def change
    add_column :messages, :message, :string
    add_column :messages, :created_at, :datetime
    add_column :messages, :updated_at, :datetime
    add_column :messages, :is_read, :boolean
  end
end
