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

ActiveRecord::Schema[7.1].define(version: 2025_03_26_160010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pre_checks", force: :cascade do |t|
    t.bigint "ride_id", null: false
    t.json "truck_inspection"
    t.json "trailer_inspection"
    t.json "driver_self_inspection"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ride_id"], name: "index_pre_checks_on_ride_id"
  end

  create_table "rides", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "truck_id", null: false
    t.string "start_location", null: false
    t.string "end_location", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["truck_id"], name: "index_rides_on_truck_id"
    t.index ["user_id"], name: "index_rides_on_user_id"
  end

  create_table "trucks", force: :cascade do |t|
    t.string "registration_number", null: false
    t.string "model"
    t.string "make"
    t.bigint "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "license_number"
    t.string "phone"
    t.datetime "license_expiry_date"
    t.integer "role", default: 1, null: false
    t.bigint "license_id"
    t.bigint "visa_id"
    t.bigint "passport_id"
    t.bigint "medical_certificate_id"
    t.bigint "police_check_id"
    t.bigint "license_history_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "worksheets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "ride_id", null: false
    t.bigint "delivery_doc_id"
    t.bigint "pickup_doc_id"
    t.bigint "start_kms"
    t.bigint "end_kms"
    t.datetime "started_on"
    t.datetime "completed_on"
    t.index ["ride_id"], name: "index_worksheets_on_ride_id"
    t.index ["user_id"], name: "index_worksheets_on_user_id"
  end

  add_foreign_key "pre_checks", "rides"
  add_foreign_key "rides", "trucks"
  add_foreign_key "rides", "users"
  add_foreign_key "worksheets", "rides"
  add_foreign_key "worksheets", "users"
end
