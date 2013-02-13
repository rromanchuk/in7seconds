class CreateRelationships < ActiveRecord::Migration
 def change
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :hookup_id
      t.string :status
      t.timestamp :accepted_at
      t.timestamps
    end
    add_index :relationships, :user_id
    add_index :relationships, :hookup_id
    add_index :relationships, [:user_id, :hookup_id], unique: true
  end
end
