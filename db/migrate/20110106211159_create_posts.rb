class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :name, :default => 'Anonymous'
      t.string :email
      t.string :subject
      t.text :message
      t.string :password
      
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
