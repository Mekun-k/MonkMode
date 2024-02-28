class AddLevelToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :level, :integer, null: false, default: 1
    add_column :users, :experience_point, :integer, null: false, default: 0
  end
end
