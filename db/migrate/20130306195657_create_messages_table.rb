class CreateMessagesTable < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :thread_id
    end
    add_index :messages, :from_user_id
    add_index :messages, :to_user_id
    add_index :messages, :thread_id

  end
end
