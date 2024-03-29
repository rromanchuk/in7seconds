class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      t.string :authentication_token

      t.boolean :is_active
      t.string :provider
      t.string :location
      t.integer :city_id
      t.integer :country_id
      t.string :city
      t.string :country
      t.integer :gender, :default => 0
      t.integer :looking_for_gender
      t.timestamp :birthday
      t.string :first_name
      t.string :last_name
      t.string :vk_token
      t.string :fb_token
      t.string :photo_url
      t.column :fbuid, :bigint
      t.column :vkuid, :bigint
      t.column "latitude", :decimal, :precision => 15, :scale => 10
      t.column "longitude", :decimal, :precision => 15, :scale => 10
      t.text :friends_list
      t.timestamps
    end
    
    add_index :users, :email
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    add_index :users, :authentication_token, :unique => true
    add_index :users, :fbuid, :unique => true
    add_index :users, :vkuid, :unique => true
    add_index :users, :is_active
    add_index :users, :gender
    add_index :users, :looking_for_gender
  end
end
