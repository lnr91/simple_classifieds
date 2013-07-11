class AddUserIdToClassifieds < ActiveRecord::Migration
  def change
    add_column :classifieds, :user_id, :integer
  end
end
