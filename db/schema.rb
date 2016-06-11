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

ActiveRecord::Schema.define(version: 20160611012555) do

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

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
    t.integer  "project_id", limit: 4
    t.string   "name",       limit: 255
    t.string   "version",    limit: 255
    t.boolean  "is_active",  limit: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "asset",      limit: 255
  end

  add_index "demos", ["project_id"], name: "index_demos_on_project_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 191, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 191
    t.datetime "created_at",                 null: false
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "assetable_id",   limit: 4
    t.string   "assetable_type", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "asset",          limit: 255
  end

  add_index "pictures", ["assetable_type", "assetable_id"], name: "index_pictures_on_assetable_type_and_assetable_id", using: :btree

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
    t.integer  "user_id",            limit: 4
    t.string   "name",               limit: 255
    t.text     "small_desc",         limit: 65535
    t.text     "full_desc",          limit: 65535
    t.text     "creator_desc",       limit: 65535
    t.integer  "state",              limit: 4,                    default: 0
    t.decimal  "funding",                          precision: 10
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "num_supporter",      limit: 4
    t.string   "crowdfunding_link",  limit: 255
    t.string   "facebook_link",      limit: 255
    t.string   "twitter_link",       limit: 255
    t.string   "website_link",       limit: 255
    t.string   "embeded_video_link", limit: 255
    t.string   "creator_name",       limit: 255
    t.datetime "ended_at"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "thredded_categories", force: :cascade do |t|
    t.integer  "messageboard_id", limit: 4,   null: false
    t.string   "name",            limit: 191, null: false
    t.string   "description",     limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "slug",            limit: 191, null: false
  end

  add_index "thredded_categories", ["messageboard_id", "slug"], name: "index_thredded_categories_on_messageboard_id_and_slug", unique: true, using: :btree
  add_index "thredded_categories", ["messageboard_id"], name: "index_thredded_categories_on_messageboard_id", using: :btree
  add_index "thredded_categories", ["name"], name: "thredded_categories_name_ci", using: :btree

  create_table "thredded_messageboard_groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "thredded_messageboard_users", force: :cascade do |t|
    t.integer  "thredded_user_detail_id",  limit: 4, null: false
    t.integer  "thredded_messageboard_id", limit: 4, null: false
    t.datetime "last_seen_at",                       null: false
  end

  add_index "thredded_messageboard_users", ["thredded_messageboard_id", "last_seen_at"], name: "index_thredded_messageboard_users_for_recently_active", using: :btree
  add_index "thredded_messageboard_users", ["thredded_messageboard_id", "thredded_user_detail_id"], name: "index_thredded_messageboard_users_primary", using: :btree
  add_index "thredded_messageboard_users", ["thredded_user_detail_id"], name: "fk_rails_06e42c62f5", using: :btree

  create_table "thredded_messageboards", force: :cascade do |t|
    t.string   "name",                  limit: 255,                   null: false
    t.string   "slug",                  limit: 191
    t.text     "description",           limit: 65535
    t.integer  "topics_count",          limit: 4,     default: 0
    t.integer  "posts_count",           limit: 4,     default: 0
    t.boolean  "closed",                limit: 1,     default: false, null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "messageboard_group_id", limit: 4
  end

  add_index "thredded_messageboards", ["closed"], name: "index_thredded_messageboards_on_closed", using: :btree
  add_index "thredded_messageboards", ["messageboard_group_id"], name: "index_thredded_messageboards_on_messageboard_group_id", using: :btree
  add_index "thredded_messageboards", ["slug"], name: "index_thredded_messageboards_on_slug", using: :btree

  create_table "thredded_post_notifications", force: :cascade do |t|
    t.string   "email",      limit: 191, null: false
    t.integer  "post_id",    limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "post_type",  limit: 191
  end

  add_index "thredded_post_notifications", ["post_id", "post_type"], name: "index_thredded_post_notifications_on_post", using: :btree

  create_table "thredded_posts", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.text     "content",         limit: 65535
    t.string   "ip",              limit: 255
    t.string   "source",          limit: 255,   default: "web"
    t.integer  "postable_id",     limit: 4
    t.integer  "messageboard_id", limit: 4,                     null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "thredded_posts", ["content"], name: "thredded_posts_content_fts", type: :fulltext
  add_index "thredded_posts", ["messageboard_id"], name: "index_thredded_posts_on_messageboard_id", using: :btree
  add_index "thredded_posts", ["postable_id"], name: "index_thredded_posts_on_postable_id", using: :btree
  add_index "thredded_posts", ["postable_id"], name: "index_thredded_posts_on_postable_id_and_postable_type", using: :btree
  add_index "thredded_posts", ["user_id"], name: "index_thredded_posts_on_user_id", using: :btree

  create_table "thredded_private_posts", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.text     "content",     limit: 65535
    t.string   "ip",          limit: 255
    t.integer  "postable_id", limit: 4,     null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "thredded_private_topics", force: :cascade do |t|
    t.integer  "user_id",      limit: 4,               null: false
    t.integer  "last_user_id", limit: 4,               null: false
    t.string   "title",        limit: 255,             null: false
    t.string   "slug",         limit: 191,             null: false
    t.integer  "posts_count",  limit: 4,   default: 0
    t.string   "hash_id",      limit: 191,             null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "thredded_private_topics", ["hash_id"], name: "index_thredded_private_topics_on_hash_id", using: :btree
  add_index "thredded_private_topics", ["slug"], name: "index_thredded_private_topics_on_slug", using: :btree

  create_table "thredded_private_users", force: :cascade do |t|
    t.integer  "private_topic_id", limit: 4
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "thredded_private_users", ["private_topic_id"], name: "index_thredded_private_users_on_private_topic_id", using: :btree
  add_index "thredded_private_users", ["user_id"], name: "index_thredded_private_users_on_user_id", using: :btree

  create_table "thredded_topic_categories", force: :cascade do |t|
    t.integer "topic_id",    limit: 4, null: false
    t.integer "category_id", limit: 4, null: false
  end

  add_index "thredded_topic_categories", ["category_id"], name: "index_thredded_topic_categories_on_category_id", using: :btree
  add_index "thredded_topic_categories", ["topic_id"], name: "index_thredded_topic_categories_on_topic_id", using: :btree

  create_table "thredded_topics", force: :cascade do |t|
    t.integer  "user_id",         limit: 4,                   null: false
    t.integer  "last_user_id",    limit: 4,                   null: false
    t.string   "title",           limit: 255,                 null: false
    t.string   "slug",            limit: 191,                 null: false
    t.integer  "messageboard_id", limit: 4,                   null: false
    t.integer  "posts_count",     limit: 4,   default: 0,     null: false
    t.boolean  "sticky",          limit: 1,   default: false, null: false
    t.boolean  "locked",          limit: 1,   default: false, null: false
    t.string   "hash_id",         limit: 191,                 null: false
    t.string   "type",            limit: 191
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "thredded_topics", ["hash_id"], name: "index_thredded_topics_on_hash_id", using: :btree
  add_index "thredded_topics", ["messageboard_id", "slug"], name: "index_thredded_topics_on_messageboard_id_and_slug", unique: true, using: :btree
  add_index "thredded_topics", ["messageboard_id"], name: "index_thredded_topics_on_messageboard_id", using: :btree
  add_index "thredded_topics", ["title"], name: "thredded_topics_title_fts", type: :fulltext
  add_index "thredded_topics", ["user_id"], name: "index_thredded_topics_on_user_id", using: :btree

  create_table "thredded_user_details", force: :cascade do |t|
    t.integer  "user_id",            limit: 4,             null: false
    t.datetime "latest_activity_at"
    t.integer  "posts_count",        limit: 4, default: 0
    t.integer  "topics_count",       limit: 4, default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "last_seen_at"
  end

  add_index "thredded_user_details", ["latest_activity_at"], name: "index_thredded_user_details_on_latest_activity_at", using: :btree
  add_index "thredded_user_details", ["user_id"], name: "index_thredded_user_details_on_user_id", using: :btree

  create_table "thredded_user_messageboard_preferences", force: :cascade do |t|
    t.integer  "user_id",           limit: 4,                null: false
    t.integer  "messageboard_id",   limit: 4,                null: false
    t.boolean  "notify_on_mention", limit: 1, default: true, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "thredded_user_messageboard_preferences", ["user_id", "messageboard_id"], name: "thredded_user_messageboard_preferences_user_id_messageboard_id", unique: true, using: :btree

  create_table "thredded_user_preferences", force: :cascade do |t|
    t.integer  "user_id",           limit: 4,                null: false
    t.boolean  "notify_on_mention", limit: 1, default: true, null: false
    t.boolean  "notify_on_message", limit: 1, default: true, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "thredded_user_preferences", ["user_id"], name: "index_thredded_user_preferences_on_user_id", using: :btree

  create_table "thredded_user_private_topic_read_states", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,             null: false
    t.integer  "postable_id", limit: 4,             null: false
    t.integer  "page",        limit: 4, default: 1, null: false
    t.datetime "read_at",                           null: false
  end

  add_index "thredded_user_private_topic_read_states", ["user_id", "postable_id"], name: "thredded_user_private_topic_read_states_user_postable", unique: true, using: :btree

  create_table "thredded_user_topic_read_states", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,             null: false
    t.integer  "postable_id", limit: 4,             null: false
    t.integer  "page",        limit: 4, default: 1, null: false
    t.datetime "read_at",                           null: false
  end

  add_index "thredded_user_topic_read_states", ["user_id", "postable_id"], name: "thredded_user_topic_read_states_user_postable", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255
    t.string   "email",                  limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.integer  "gender",                 limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "admin",                  limit: 1,   default: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "remember_token",         limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.integer  "assetable_id",   limit: 4
    t.string   "assetable_type", limit: 255
    t.string   "name",           limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "asset",          limit: 255
  end

  add_index "videos", ["assetable_type", "assetable_id"], name: "index_videos_on_assetable_type_and_assetable_id", using: :btree

  add_foreign_key "thredded_messageboard_users", "thredded_messageboards"
  add_foreign_key "thredded_messageboard_users", "thredded_user_details"
end
