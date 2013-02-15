class RevertMessageColumn < ActiveRecord::Migration
  def change
    rename_column :messages, :message_text, :message
  end
end
