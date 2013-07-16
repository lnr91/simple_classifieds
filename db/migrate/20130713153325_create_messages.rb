class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from_id
      t.integer :to_id
      t.string :content
      t.references :classified

      t.timestamps
    end
    add_index :messages, :classified_id
  end
end
