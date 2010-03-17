# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100315094549) do

  create_table "ms_languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "translation_jobs", :force => true do |t|
    t.integer  "source_id"
    t.integer  "target_id"
    t.string   "from_lang"
    t.string   "to_lang"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweet_translations", :force => true do |t|
    t.integer  "tweet_id"
    t.integer  "service_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "twitter_id",      :limit => 8
    t.string   "text"
    t.string   "irt_screen_name"
    t.integer  "irt_user_id"
    t.string   "irt_status_id"
    t.string   "contributors"
    t.string   "source"
    t.boolean  "favorited"
    t.string   "geo"
    t.boolean  "status"
    t.string   "json"
    t.datetime "tw_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_accounts", :force => true do |t|
    t.string   "username"
    t.integer  "user_id"
    t.string   "password"
    t.string   "since_id"
    t.datetime "tweets_fetched_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
