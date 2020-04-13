# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_13_182611) do

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "address"
  end

  create_table "couriers", force: :cascade do |t|
    t.string "name"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "pickup_address"
    t.string "dropoff_address"
    t.datetime "time_ordered", default: "2020-04-13 18:11:33"
    t.datetime "time_delivered"
    t.string "status", default: "pending"
    t.string "pod"
    t.boolean "rush"
    t.boolean "oversize"
    t.integer "client_id"
    t.integer "courier_id"
  end

end
