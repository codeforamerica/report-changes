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

ActiveRecord::Schema.define(version: 2018_10_12_184307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.inet "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.inet "last_sign_in_ip"
    t.string "otp_auth_secret"
    t.datetime "otp_challenge_expires"
    t.boolean "otp_enabled", default: false, null: false
    t.datetime "otp_enabled_on"
    t.integer "otp_failed_attempts", default: 0, null: false
    t.boolean "otp_mandatory", default: false, null: false
    t.string "otp_persistence_seed"
    t.integer "otp_recovery_counter", default: 0, null: false
    t.string "otp_recovery_secret"
    t.string "otp_session_challenge"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["otp_challenge_expires"], name: "index_admin_users_on_otp_challenge_expires"
    t.index ["otp_session_challenge"], name: "index_admin_users_on_otp_session_challenge", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "change_report_navigators", force: :cascade do |t|
    t.bigint "change_report_id"
    t.string "city"
    t.string "county_from_address"
    t.datetime "created_at", null: false
    t.integer "has_letter", default: 0
    t.integer "selected_county_location", default: 0
    t.string "source"
    t.string "street_address"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["change_report_id"], name: "index_change_report_navigators_on_change_report_id"
  end

  create_table "change_reports", force: :cascade do |t|
    t.string "case_number"
    t.integer "change_type", default: 0
    t.string "company_name"
    t.integer "consent_to_sms", default: 0
    t.datetime "created_at", null: false
    t.text "feedback_comments"
    t.integer "feedback_rating", default: 0
    t.datetime "last_day"
    t.datetime "last_paycheck"
    t.decimal "last_paycheck_amount", precision: 8, scale: 2
    t.string "manager_additional_information"
    t.string "manager_name"
    t.string "manager_phone_number"
    t.string "phone_number"
    t.string "signature"
    t.datetime "submitted_at"
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at"
    t.datetime "failed_at"
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "locked_at"
    t.string "locked_by"
    t.integer "priority", default: 0, null: false
    t.string "queue"
    t.datetime "run_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "household_members", force: :cascade do |t|
    t.datetime "birthday"
    t.bigint "change_report_id"
    t.datetime "created_at", null: false
    t.string "encrypted_ssn"
    t.string "encrypted_ssn_iv"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["change_report_id"], name: "index_household_members_on_change_report_id"
  end

end
