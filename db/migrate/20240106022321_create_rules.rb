class CreateRules < ActiveRecord::Migration[6.1]
  def change
    create_table :rules do |t|
      t.string :rule_title, null: false
      t.string :rule_content, null: false
      t.boolean :rule_type_id, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
