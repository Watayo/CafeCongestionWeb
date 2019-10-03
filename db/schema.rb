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

ActiveRecord::Schema.define(version: 2019_10_02_052124) do

  create_table "areas", force: :cascade do |t|
    t.string "name"
  end

  create_table "cafes", force: :cascade do |t|
    t.string "cafe_name"
    t.integer "seat_num"
    t.integer "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_cafes_on_area_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.integer "good_num"
    t.string "Thanks"
    t.integer "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_users_on_area_id"
  end

  create_table "users_cafes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "cafe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cafe_id"], name: "index_users_cafes_on_cafe_id"
    t.index ["user_id"], name: "index_users_cafes_on_user_id"
  end

end
