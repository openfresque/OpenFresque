# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2021_11_19_233449) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "training_sessions", force: :cascade do |t|
    t.text "description"
    t.date "date", null: false
    t.datetime "start_time", precision: nil, null: false
    t.datetime "end_time", precision: nil, null: false
    t.string "category", null: false
    t.string "format", null: false
    t.string "connexion_url"
    t.string "room"
    t.string "street"
    t.string "city"
    t.string "zip"
    t.integer "capacity", default: 0
    t.boolean "public"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "time_zone", default: "Paris", null: false
    t.integer "country_id", null: false
    t.integer "created_by_user_id", default: 1, null: false
    t.text "session_info"
    t.integer "language_id", null: false
    t.float "latitude"
    t.float "longitude"
    t.text "animator_session_info"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest", null: false
    t.boolean "admin", default: false, null: false
    t.string "token", null: false
    t.string "refresh_token", null: false
    t.string "language", default: "fr", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["refresh_token"], name: "index_users_on_refresh_token", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

end
