class AddColumnSelfIntroduction < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :self_introduction, :string
  end
end
