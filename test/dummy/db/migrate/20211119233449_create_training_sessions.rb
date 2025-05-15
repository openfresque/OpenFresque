class CreateTrainingSessions < ActiveRecord::Migration[6.0]
  def change
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
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "time_zone", default: "Paris", null: false
      t.integer "country_id", null: false
      t.integer "created_by_user_id", default: 1, null: false
      t.text "session_info"
      t.integer "language_id", null: false
      t.float "latitude"
      t.float "longitude"
      t.text "animator_session_info"
    end
  end
end
