class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :name, :default => 'Anonymous'
      t.string :email
      t.string :subject
      t.text :message
      t.boolean :tripcoded
      t.string :client_ip
      t.integer :post_id

      t.timestamps
    end
    add_index :comments, :post_id
  end

  def self.down
    remove_index :comments, :post_id
    drop_table :comments
  end
end