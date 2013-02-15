class FixIsReadColumn < ActiveRecord::Migration
  def change
    rename_column :messages, :message, :message_text
  end
end
