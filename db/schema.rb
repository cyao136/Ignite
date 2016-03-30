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

ActiveRecord::Schema.define(version: 20160330223943) do

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.text     "text",             limit: 65535
    t.integer  "type",             limit: 4
    t.integer  "like",             limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree

  create_table "demos", force: :cascade do |t|
    t.integer  "project_id",         limit: 4
    t.string   "name",               limit: 255
    t.string   "location",           limit: 255
    t.string   "version",            limit: 255
    t.boolean  "is_active",          limit: 1
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "asset_file_name",    limit: 255
    t.string   "asset_content_type", limit: 255
    t.integer  "asset_file_size",    limit: 4
    t.datetime "asset_updated_at"
  end

  add_index "demos", ["project_id"], name: "index_demos_on_project_id", using: :btree

  create_table "genres", force: :cascade do |t|
    t.integer  "project_id",  limit: 4
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "genres", ["project_id"], name: "index_genres_on_project_id", using: :btree

  create_table "genres_projects", id: false, force: :cascade do |t|
    t.integer "genre_id",   limit: 4
    t.integer "project_id", limit: 4
  end

  add_index "genres_projects", ["genre_id"], name: "index_genres_projects_on_genre_id", using: :btree
  add_index "genres_projects", ["project_id"], name: "index_genres_projects_on_project_id", using: :btree

  create_table "goals", force: :cascade do |t|
    t.integer  "project_id",        limit: 4
    t.decimal  "goal_value",                  precision: 10
    t.decimal  "cur_value",                   precision: 10
    t.boolean  "goal_overflowable", limit: 1
    t.boolean  "goal_is_met",       limit: 1
    t.boolean  "is_monetary",       limit: 1
    t.boolean  "is_active",         limit: 1
    t.integer  "activating_state",  limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "goals", ["project_id"], name: "index_goals_on_project_id", using: :btree

  create_table "new_pictures", force: :cascade do |t|
    t.integer  "asset_id",           limit: 4
    t.string   "asset_type",         limit: 255
    t.string   "name",               limit: 255
    t.string   "asset_file_name",    limit: 255
    t.string   "asset_content_type", limit: 255
    t.integer  "asset_file_size",    limit: 4
    t.datetime "asset_updated_at"
  end

  add_index "new_pictures", ["asset_type", "asset_id"], name: "index_new_pictures_on_asset_type_and_asset_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.integer  "asset_id",           limit: 4
    t.string   "asset_type",         limit: 255
    t.string   "name",               limit: 255
    t.string   "file_extension",     limit: 255
    t.string   "location",           limit: 255
    t.string   "tag",                limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "asset_file_name",    limit: 255
    t.string   "asset_content_type", limit: 255
    t.integer  "asset_file_size",    limit: 4
    t.datetime "asset_updated_at"
  end

  add_index "pictures", ["asset_type", "asset_id"], name: "index_pictures_on_asset_type_and_asset_id", using: :btree

  create_table "pledges", force: :cascade do |t|
    t.integer  "project_id",  limit: 4
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.decimal  "cost",                      precision: 10
    t.integer  "max_number",  limit: 4
    t.boolean  "is_active",   limit: 1
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "pledges", ["project_id"], name: "index_pledges_on_project_id", using: :btree

  create_table "pledges_users", id: false, force: :cascade do |t|
    t.integer "pledge_id", limit: 4
    t.integer "user_id",   limit: 4
  end

  add_index "pledges_users", ["pledge_id"], name: "index_pledges_users_on_pledge_id", using: :btree
  add_index "pledges_users", ["user_id"], name: "index_pledges_users_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "project_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "type",       limit: 4
    t.text     "message",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "posts", ["project_id"], name: "index_posts_on_project_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "name",         limit: 255
    t.text     "small_desc",   limit: 65535
    t.text     "full_desc",    limit: 65535
    t.text     "team_desc",    limit: 65535
    t.text     "creator_desc", limit: 65535
    t.integer  "state",        limit: 4
    t.decimal  "funding",                    precision: 10
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",            limit: 255
    t.string   "email",               limit: 255
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.integer  "gender",              limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "password_digest",     limit: 255
    t.string   "remember_digest",     limit: 255
    t.string   "activation_digest",   limit: 255
    t.boolean  "activated",           limit: 1,   default: false
    t.datetime "activated_at"
    t.string   "reset_digest",        limit: 255
    t.datetime "reset_sent_at"
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
  end

  create_table "videos", force: :cascade do |t|
    t.integer  "asset_id",           limit: 4
    t.string   "asset_type",         limit: 255
    t.string   "name",               limit: 255
    t.string   "file_extension",     limit: 255
    t.string   "location",           limit: 255
    t.string   "tag",                limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "asset_file_name",    limit: 255
    t.string   "asset_content_type", limit: 255
    t.integer  "asset_file_size",    limit: 4
    t.datetime "asset_updated_at"
  end

  add_index "videos", ["asset_type", "asset_id"], name: "index_videos_on_asset_type_and_asset_id", using: :btree

end
