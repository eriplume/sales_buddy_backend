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

ActiveRecord::Schema[7.0].define(version: 2023_12_20_072159) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customer_records", force: :cascade do |t|
    t.integer "count", null: false
    t.bigint "dairy_record_id", null: false
    t.bigint "customer_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_type_id"], name: "index_customer_records_on_customer_type_id"
    t.index ["dairy_record_id"], name: "index_customer_records_on_dairy_record_id"
  end

  create_table "customer_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dairy_records", force: :cascade do |t|
    t.integer "total_amount", null: false
    t.integer "total_number", null: false
    t.integer "count", null: false
    t.float "set_rate", null: false
    t.float "average_spend", null: false
    t.date "date", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "date"], name: "index_dairy_records_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_dairy_records_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "line_id", null: false
    t.boolean "notifications", default: false
    t.integer "role", default: 0, null: false
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["group_id"], name: "index_users_on_group_id"
  end

  create_table "weekly_reports", force: :cascade do |t|
    t.text "content", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "start_date"], name: "index_weekly_reports_on_user_id_and_start_date", unique: true
    t.index ["user_id"], name: "index_weekly_reports_on_user_id"
  end

  create_table "weekly_targets", force: :cascade do |t|
    t.integer "target", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "start_date"], name: "index_weekly_targets_on_user_id_and_start_date", unique: true
    t.index ["user_id"], name: "index_weekly_targets_on_user_id"
  end

  add_foreign_key "customer_records", "customer_types"
  add_foreign_key "customer_records", "dairy_records"
  add_foreign_key "dairy_records", "users"
  add_foreign_key "users", "groups"
  add_foreign_key "weekly_reports", "users"
  add_foreign_key "weekly_targets", "users"
end
