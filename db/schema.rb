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

ActiveRecord::Schema.define(version: 20160223105126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "external_ratings", force: :cascade do |t|
    t.integer  "avg_rating"
    t.float    "nb_ratings"
    t.integer  "wine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "external_ratings", ["wine_id"], name: "index_external_ratings_on_wine_id", using: :btree

  create_table "store_schedules", force: :cascade do |t|
    t.integer  "store_id"
    t.time     "start_at"
    t.time     "close_at"
    t.integer  "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "store_schedules", ["store_id"], name: "index_store_schedules_on_store_id", using: :btree

  create_table "stores", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "brand"
  end

  create_table "user_answers", force: :cascade do |t|
    t.string   "question1"
    t.string   "question2"
    t.string   "question3"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_answers", ["user_id"], name: "index_user_answers_on_user_id", using: :btree

  create_table "user_ratings", force: :cascade do |t|
    t.string   "status"
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "wine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_ratings", ["user_id"], name: "index_user_ratings_on_user_id", using: :btree
  add_index "user_ratings", ["wine_id"], name: "index_user_ratings_on_wine_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wines", force: :cascade do |t|
    t.string   "color"
    t.string   "name"
    t.string   "vintage"
    t.string   "cepage_1"
    t.string   "cepage_2"
    t.string   "cepage_3"
    t.float    "cepage_percent_1"
    t.float    "cepage_percent_2"
    t.float    "cepage_percent_3"
    t.integer  "store_id"
    t.string   "pairing_1"
    t.string   "pairing_2"
    t.string   "pairing_3"
    t.string   "description"
    t.string   "appellation"
    t.string   "region"
    t.string   "acidity"
    t.float    "alcohol_percent"
    t.float    "avg_rating"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "wines", ["store_id"], name: "index_wines_on_store_id", using: :btree

  add_foreign_key "external_ratings", "wines"
  add_foreign_key "store_schedules", "stores"
  add_foreign_key "user_answers", "users"
  add_foreign_key "user_ratings", "users"
  add_foreign_key "user_ratings", "wines"
  add_foreign_key "wines", "stores"
end
