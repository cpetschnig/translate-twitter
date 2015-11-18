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

ActiveRecord::Schema.define(:version => 20151118172027) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                             :default => "", :null => false
    t.string   "encrypted_password",                :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.integer  "uid",                  :limit => 5
    t.string   "token"
    t.string   "token_secret"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "admin_users", ["uid"], :name => "index_admin_users_on_uid", :unique => true

  create_table "ms_languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "translation_jobs", :force => true do |t|
    t.integer  "source_id"
    t.integer  "target_id"
    t.string   "from_lang"
    t.string   "to_lang"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tweet_translations", :force => true do |t|
    t.integer  "tweet_id"
    t.integer  "service_id"
    t.string   "text",       :limit => 512
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "tweet_translations", ["tweet_id"], :name => "index_tweet_translations_on_tweet_id"

  create_table "tweets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "twitter_id",      :limit => 8
    t.string   "text"
    t.string   "irt_screen_name"
    t.integer  "irt_user_id",     :limit => 5
    t.string   "irt_status_id"
    t.string   "contributors"
    t.string   "source"
    t.boolean  "favorited"
    t.string   "geo"
    t.boolean  "status"
    t.string   "json"
    t.datetime "tw_created_at"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "tweets", ["twitter_id"], :name => "index_tweets_on_twitter_id"

  create_table "twitter_accounts", :force => true do |t|
    t.string   "username"
    t.integer  "user_id",            :limit => 5
    t.string   "password"
    t.string   "since_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "can_publish"
    t.string   "image_url",          :limit => 128
    t.string   "real_name",          :limit => 32
    t.integer  "followers"
    t.string   "consumer_key",       :limit => 32
    t.string   "consumer_secret",    :limit => 64
    t.string   "access_token",       :limit => 64
    t.string   "access_secret",      :limit => 64
    t.datetime "created_at_twitter"
    t.string   "location"
    t.string   "description"
    t.integer  "friends"
    t.integer  "statuses"
  end

  add_index "twitter_accounts", ["username"], :name => "index_twitter_accounts_on_username", :unique => true

end
