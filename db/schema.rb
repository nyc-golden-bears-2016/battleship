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

ActiveRecord::Schema.define(version: 20160803141821) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "player_1_id"
    t.integer  "player_2_id"
    t.boolean  "player_1_setup", default: false
    t.boolean  "player_2_setup", default: false
    t.integer  "winner_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "ships", force: :cascade do |t|
    t.string   "name"
    t.integer  "length"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tiles", force: :cascade do |t|
    t.string   "coordinates"
    t.boolean  "hit",         default: false
    t.integer  "ship_id"
    t.integer  "game_id"
    t.integer  "player_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
