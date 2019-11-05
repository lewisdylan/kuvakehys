class InitialMerged < ActiveRecord::Migration[5.2]
  def change
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
      t.bigint "byte_size", null: false
      t.string "checksum", null: false
      t.datetime "created_at", null: false
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end

    create_table "collections", force: :cascade do |t|
      t.string "name"
      t.text "description"
      t.string "identifier"
      t.bigint "user_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["identifier"], name: "index_collections_on_identifier"
      t.index ["user_id"], name: "index_collections_on_user_id"
    end

    create_table "collectionships", force: :cascade do |t|
      t.integer "photo_id"
      t.integer "collection_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "gutentag_taggings", id: :serial, force: :cascade do |t|
      t.integer "tag_id", null: false
      t.integer "taggable_id", null: false
      t.string "taggable_type", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["tag_id"], name: "index_gutentag_taggings_on_tag_id"
      t.index ["taggable_type", "taggable_id", "tag_id"], name: "unique_taggings", unique: true
      t.index ["taggable_type", "taggable_id"], name: "index_gutentag_taggings_on_taggable_type_and_taggable_id"
    end

    create_table "gutentag_tags", id: :serial, force: :cascade do |t|
      t.string "name", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "taggings_count", default: 0, null: false
      t.index ["name"], name: "index_gutentag_tags_on_name", unique: true
      t.index ["taggings_count"], name: "index_gutentag_tags_on_taggings_count"
    end

    create_table "invitations", force: :cascade do |t|
      t.string "identifier"
      t.bigint "collection_id"
      t.bigint "user_id"
      t.bigint "sender_id"
      t.string "email"
      t.text "message"
      t.datetime "accepted_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["collection_id"], name: "index_invitations_on_collection_id"
      t.index ["identifier"], name: "index_invitations_on_identifier"
      t.index ["sender_id"], name: "index_invitations_on_sender_id"
      t.index ["user_id"], name: "index_invitations_on_user_id"
    end

    create_table "memberships", force: :cascade do |t|
      t.integer "collection_id"
      t.integer "user_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "invitation_id"
    end

    create_table "orders", id: :serial, force: :cascade do |t|
      t.integer "group_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "print_order_id"
      t.string "status"
      t.integer "user_id"
    end

    create_table "photos", id: :serial, force: :cascade do |t|
      t.integer "user_id"
      t.string "identifier"
      t.text "caption"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "file_fingerprint"
      t.index ["identifier"], name: "index_photos_on_identifier"
    end

    create_table "users", id: :serial, force: :cascade do |t|
      t.string "identifier"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "email"
      t.string "name"
      t.datetime "last_inactivity_notifier_at"
      t.integer "inactivity_notifications_count", default: 0
      t.datetime "last_upload_at"
      t.string "device_id"
      t.index ["device_id"], name: "index_users_on_device_id"
      t.index ["identifier"], name: "index_users_on_identifier"
    end
  end
end
