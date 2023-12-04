ActiveRecord::Schema[7.0].define(version: 2023_12_04_084201) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "line_id", null: false
    t.boolean "notifications", default: false
    t.integer "role", default: 0, null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["group_id"], name: "index_users_on_group_id"
  end

  add_foreign_key "users", "groups"
end
