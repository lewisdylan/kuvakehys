# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151110135046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "photo_limit"
    t.string   "recipient_name"
    t.string   "recipient_address_1"
    t.string   "recipient_postal_code"
    t.string   "recipient_city"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "owner_name"
    t.string   "owner_email"
    t.string   "recipient_address_2"
    t.string   "recipient_country"
    t.string   "identifier"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "group_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "print_order_id"
    t.string   "status"
    t.integer  "user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "order_id"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.integer  "width"
    t.integer  "height"
    t.string   "sender_email"
    t.string   "sender_name"
    t.text     "message"
    t.text     "subject"
    t.text     "body"
    t.string   "message_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "picture_fingerprint"
    t.integer  "user_id"
  end

  create_table "recipient_orders", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "recipient_id"
    t.integer  "group_id"
    t.string   "print_order_id"
    t.string   "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "recipients", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "postal_code"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone"
    t.integer  "group_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "email"
    t.string   "name"
    t.string   "telegram_id"
    t.datetime "last_inactivity_notifier_at"
    t.integer  "inactivity_notifications_count"
    t.datetime "last_import_at"
  end

end
