class ChangeDefaultHasPasswordOfUsers < ActiveRecord::Migration
  def up
    change_column :users, :has_password,  :boolean, default: true
  end

  def down
  end
end
