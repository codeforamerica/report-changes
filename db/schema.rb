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

ActiveRecord::Schema.define(version: 2018_09_19_172745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "change_report_navigators", force: :cascade do |t|
    t.bigint "change_report_id"
    t.string "city"
    t.string "county_from_address"
    t.datetime "created_at", null: false
    t.integer "selected_county_location", default: 0
    t.string "street_address"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["change_report_id"], name: "index_change_report_navigators_on_change_report_id"
  end

  create_table "change_reports", force: :cascade do |t|
    t.string "case_number"
    t.string "company_address"
    t.string "company_name"
    t.string "company_phone_number"
    t.datetime "created_at", null: false
    t.datetime "last_day"
    t.datetime "last_paycheck"
    t.string "phone_number"
    t.string "signature"
    t.datetime "updated_at", null: false
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
