class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    enable_extension "uuid-ossp" unless extension_enabled?("uuid-ossp")
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table "users", force: :cascade do |t|
      t.string "email", null: false
      t.string "first_name"
      t.string "last_name"
      t.string "password_digest", null: false
      t.boolean "admin", default: false, null: false
      t.string "token", null: false
      t.string "refresh_token", null: false
      t.string "language", default: "fr", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["refresh_token"], name: "index_users_on_refresh_token", unique: true
      t.index ["token"], name: "index_users_on_token", unique: true
    end
  end
end
