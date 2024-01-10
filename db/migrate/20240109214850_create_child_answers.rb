class CreateChildAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :child_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :rule, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true
      t.boolean :contnet, null: false, default: false

      t.timestamps
    end
  end
end
