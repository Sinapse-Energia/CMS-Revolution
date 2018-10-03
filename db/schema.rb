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

ActiveRecord::Schema.define(version: 2018_10_01_082620) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "static_data", force: :cascade do |t|
    t.text "name", null: false
    t.text "id_code", null: false
    t.text "id_communication", null: false
    t.text "location", null: false
    t.decimal "longitude", precision: 8, scale: 2, null: false
    t.decimal "latitude", precision: 8, scale: 2, null: false
    t.decimal "altitude", precision: 8, scale: 2, null: false
    t.datetime "date_installation", null: false
    t.integer "circuit_number", null: false
    t.text "name_street"
    t.text "number_street"
    t.text "power_installed"
    t.text "power_contracted"
    t.text "id_supply_contract"
    t.text "clock_brand"
    t.text "clock_model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "token"
    t.string "password"
    t.string "password_digest"
    t.string "password_reset_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
