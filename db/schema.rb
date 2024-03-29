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

ActiveRecord::Schema.define(version: 20140205062932) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "description"
    t.decimal  "mets",        precision: 3, scale: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exercise_stats", force: true do |t|
    t.integer  "duration"
    t.integer  "calories_burned"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exercise_stats", ["user_id"], name: "index_exercise_stats_on_user_id", using: :btree

  create_table "food_stats", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "calories"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "food_stats", ["user_id"], name: "index_food_stats_on_user_id", using: :btree

  create_table "goal_types", force: true do |t|
    t.string   "goal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "calorie_adj"
  end

  create_table "tdee_factors", force: true do |t|
    t.string   "level_name"
    t.string   "description"
    t.decimal  "multiplier",  precision: 4, scale: 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_vitals", force: true do |t|
    t.string   "gender",         limit: 1
    t.integer  "height"
    t.integer  "start_weight"
    t.integer  "target_weight"
    t.integer  "bmi"
    t.integer  "bmr"
    t.integer  "user_id"
    t.integer  "goal_type_id"
    t.integer  "tdee_factor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "age"
  end

  add_index "user_vitals", ["goal_type_id"], name: "index_user_vitals_on_goal_type_id", using: :btree
  add_index "user_vitals", ["tdee_factor_id"], name: "index_user_vitals_on_tdee_factor_id", using: :btree
  add_index "user_vitals", ["user_id"], name: "index_user_vitals_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",      limit: 60
    t.string   "last_name",       limit: 60
    t.string   "email"
    t.string   "password_digest"
    t.string   "pic_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weight_stats", force: true do |t|
    t.integer  "weight"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weight_stats", ["user_id"], name: "index_weight_stats_on_user_id", using: :btree

end
