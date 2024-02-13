class DropSnsCredential < ActiveRecord::Migration[6.1]
  def up
    drop_table :sns_credentials
  end

  def down
    drop_table :sns_credentials do |t|
      t.string "provider"
      t.string "uid"
      t.bigint "user_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["user_id"], name: "index_sns_credentials_on_user_id"
    end
  end
end
