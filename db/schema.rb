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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130921165818) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.binary   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "fb_locations", force: true do |t|
    t.string  "name"
    t.integer "lid",  limit: 8
  end

  add_index "fb_locations", ["lid"], name: "index_fb_locations_on_lid", using: :btree

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true, using: :btree
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id", using: :btree

  create_table "groups", force: true do |t|
    t.integer "gid"
    t.string  "name"
    t.string  "photo"
    t.string  "provider"
  end

  add_index "groups", ["gid"], name: "index_groups_on_gid", using: :btree
  add_index "groups", ["provider"], name: "index_groups_on_provider", using: :btree

  create_table "images", force: true do |t|
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.string   "remote_url"
    t.string   "provider"
    t.integer  "external_id",        limit: 8
    t.boolean  "is_uploaded",                  default: false
    t.integer  "profile_position"
  end

  add_index "images", ["external_id"], name: "index_images_on_external_id", using: :btree
  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["user_id", "group_id"], name: "index_memberships_on_user_id_and_group_id", unique: true, using: :btree

  create_table "messages", force: true do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.integer  "thread_id"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_read",      default: false
  end

  add_index "messages", ["from_user_id"], name: "index_messages_on_from_user_id", using: :btree
  add_index "messages", ["thread_id"], name: "index_messages_on_thread_id", using: :btree
  add_index "messages", ["to_user_id"], name: "index_messages_on_to_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "is_read",           default: false
    t.string   "notification_type"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "message"
  end

  add_index "notifications", ["receiver_id"], name: "index_notifications_on_receiver_id", using: :btree
  add_index "notifications", ["sender_id"], name: "index_notifications_on_sender_id", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "hookup_id"
    t.string   "status"
    t.datetime "accepted_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "requested_in_num_seconds"
  end

  add_index "relationships", ["hookup_id"], name: "index_relationships_on_hookup_id", using: :btree
  add_index "relationships", ["user_id", "hookup_id"], name: "index_relationships_on_user_id_and_hookup_id", unique: true, using: :btree
  add_index "relationships", ["user_id"], name: "index_relationships_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password",                                         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                              default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.boolean  "is_active"
    t.string   "provider"
    t.boolean  "gender",                                                     default: false
    t.datetime "birthday"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "vk_token"
    t.string   "fb_token"
    t.string   "photo_url"
    t.integer  "fbuid",                  limit: 8
    t.integer  "vkuid",                  limit: 8
    t.decimal  "latitude",                         precision: 15, scale: 10
    t.decimal  "longitude",                        precision: 15, scale: 10
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.integer  "looking_for_gender"
    t.string   "vk_domain"
    t.string   "vk_university_name"
    t.string   "vk_faculty_name"
    t.string   "vk_mobile_phone"
    t.string   "vk_graduation"
    t.integer  "vk_country_id"
    t.integer  "vk_city_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "email_opt_in",                                               default: true
    t.boolean  "push_opt_in",                                                default: true
    t.datetime "vk_token_expiration"
    t.datetime "fb_token_expiration"
    t.string   "fb_domain"
    t.integer  "fb_location_id"
    t.string   "status"
    t.boolean  "admin",                                                      default: false
    t.integer  "num_requests"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["fb_location_id"], name: "index_users_on_fb_location_id", using: :btree
  add_index "users", ["fbuid"], name: "index_users_on_fbuid", unique: true, using: :btree
  add_index "users", ["gender"], name: "index_users_on_gender", using: :btree
  add_index "users", ["is_active"], name: "index_users_on_is_active", using: :btree
  add_index "users", ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude", using: :btree
  add_index "users", ["looking_for_gender"], name: "index_users_on_looking_for_gender", using: :btree
  add_index "users", ["num_requests"], name: "index_users_on_num_requests", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["vk_city_id"], name: "index_users_on_vk_city_id", using: :btree
  add_index "users", ["vk_country_id"], name: "index_users_on_vk_country_id", using: :btree
  add_index "users", ["vkuid"], name: "index_users_on_vkuid", unique: true, using: :btree

  create_table "vk_cities", force: true do |t|
    t.string  "name"
    t.integer "cid"
  end

  add_index "vk_cities", ["cid"], name: "index_vk_cities_on_cid", using: :btree

  create_table "vk_countries", force: true do |t|
    t.string  "name"
    t.integer "cid"
  end

  add_index "vk_countries", ["cid"], name: "index_vk_countries_on_cid", using: :btree

end
