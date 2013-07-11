class AddEmailActivationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_activation_token, :string
    add_column :users, :email_activated, :boolean
  end
end
