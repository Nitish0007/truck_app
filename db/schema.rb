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

ActiveRecord::Schema[7.1].define(version: 2025_04_04_171246) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "truck_id"
    t.bigint "worksheet_id"
    t.string "source_class"
    t.string "document_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["truck_id"], name: "index_documents_on_truck_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
    t.index ["worksheet_id"], name: "index_documents_on_worksheet_id"
  end

  create_table "pre_checks", force: :cascade do |t|
    t.bigint "ride_id", null: false
    t.jsonb "truck_inspection"
    t.jsonb "trailer_inspection"
    t.jsonb "driver_self_inspection"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "worksheets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "ride_id", null: false
    t.bigint "start_kms"
    t.bigint "end_kms"
    t.datetime "started_on"
    t.datetime "completed_on"
    t.index ["ride_id"], name: "index_worksheets_on_ride_id"
    t.index ["user_id"], name: "index_worksheets_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "documents", "trucks"
  add_foreign_key "documents", "users"
  add_foreign_key "documents", "worksheets"
  add_foreign_key "pre_checks", "rides"
  add_foreign_key "rides", "trucks"
  add_foreign_key "rides", "users"
  add_foreign_key "worksheets", "rides"
  add_foreign_key "worksheets", "users"
end
