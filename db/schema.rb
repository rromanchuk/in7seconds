# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130306195657) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id", :unique => true
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "groups", :force => true do |t|
    t.integer "gid"
    t.string  "name"
    t.string  "photo"
    t.string  "provider"
  end

  add_index "groups", ["gid"], :name => "index_groups_on_gid"
  add_index "groups", ["provider"], :name => "index_groups_on_provider"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["user_id", "group_id"], :name => "index_memberships_on_user_id_and_group_id", :unique => true

  create_table "messages", :force => true do |t|
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.integer "thread_id"
  end

  add_index "messages", ["from_user_id"], :name => "index_messages_on_from_user_id"
  add_index "messages", ["thread_id"], :name => "index_messages_on_thread_id"
  add_index "messages", ["to_user_id"], :name => "index_messages_on_to_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "hookup_id"
    t.string   "status"
    t.datetime "accepted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["hookup_id"], :name => "index_relationships_on_hookup_id"
  add_index "relationships", ["user_id", "hookup_id"], :name => "index_relationships_on_user_id_and_hookup_id", :unique => true
  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",                                                  :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.boolean  "is_active"
    t.string   "provider"
    t.boolean  "gender",                                                              :default => false
    t.datetime "birthday"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "vk_token"
    t.string   "fb_token"
    t.string   "photo_url"
    t.integer  "fbuid",                  :limit => 8
    t.integer  "vkuid",                  :limit => 8
    t.decimal  "latitude",                            :precision => 15, :scale => 10
    t.decimal  "longitude",                           :precision => 15, :scale => 10
    t.datetime "created_at",                                                                             :null => false
    t.datetime "updated_at",                                                                             :null => false
    t.integer  "looking_for_gender"
    t.string   "vk_domain"
    t.string   "vk_university_name"
    t.string   "vk_faculty_name"
    t.string   "vk_mobile_phone"
    t.string   "vk_graduation"
    t.integer  "vk_country_id"
    t.integer  "vk_city_id"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["fbuid"], :name => "index_users_on_fbuid", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["vk_city_id"], :name => "index_users_on_vk_city_id"
  add_index "users", ["vk_country_id"], :name => "index_users_on_vk_country_id"
  add_index "users", ["vkuid"], :name => "index_users_on_vkuid", :unique => true

  create_table "vk_cities", :force => true do |t|
    t.string  "name"
    t.integer "cid"
  end

  add_index "vk_cities", ["cid"], :name => "index_vk_cities_on_cid"

  create_table "vk_countries", :force => true do |t|
    t.string  "name"
    t.integer "cid"
  end

  add_index "vk_countries", ["cid"], :name => "index_vk_countries_on_cid"

end
