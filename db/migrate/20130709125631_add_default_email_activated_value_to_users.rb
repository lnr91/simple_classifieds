class AddDefaultEmailActivatedValueToUsers < ActiveRecord::Migration
  def change
    change_column :users, :email_activated, :boolean,default: false
  end
end
