class ChangeAdminDefaultToUsers < ActiveRecord::Migration
  def up
    change_column :users, :admin, :boolean ,default: false
  end

end
