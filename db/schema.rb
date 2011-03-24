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

ActiveRecord::Schema.define(:version => 20110324143027) do

  create_table "admins", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "bans", :force => true do |t|
    t.string   "client_ip"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expires_at"
    t.boolean  "permanent"
    t.boolean  "destructive"
    t.boolean  "nullify"
  end

  add_index "bans", ["client_ip"], :name => "index_bans_on_client_ip"

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "posts_count",    :default => 0
    t.integer  "category_id"
    t.integer  "comments_count", :default => 0
  end

  add_index "boards", ["category_id"], :name => "index_boards_on_category_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "name",                    :default => "Anonymous"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.boolean  "tripcoded"
    t.string   "client_ip"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "commentpic_file_name"
    t.string   "commentpic_content_type"
    t.integer  "commentpic_file_size"
    t.datetime "commentpic_updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "comments_count",          :default => 0
    t.integer  "image_width",             :default => 0
    t.integer  "image_height",            :default => 0
  end

  add_index "comments", ["client_ip"], :name => "index_comments_on_client_ip"
  add_index "comments", ["created_at", "post_id"], :name => "index_comments_on_created_at_and_post_id"
  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"

  create_table "posts", :force => true do |t|
    t.string   "name",                 :default => "Anonymous"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "postpic_file_name"
    t.string   "postpic_content_type"
    t.integer  "postpic_file_size"
    t.datetime "postpic_updated_at"
    t.boolean  "tripcoded"
    t.integer  "position"
    t.string   "client_ip"
    t.integer  "comments_count",       :default => 0
    t.integer  "board_id"
    t.boolean  "locked",               :default => false
    t.boolean  "sticky",               :default => false
    t.integer  "image_width",          :default => 0
    t.integer  "image_height",         :default => 0
  end

  add_index "posts", ["board_id"], :name => "index_posts_on_board_id"
  add_index "posts", ["client_ip"], :name => "index_posts_on_client_ip"

end
