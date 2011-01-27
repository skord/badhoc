class DropPasswordsFromCommentsAndPosts < ActiveRecord::Migration
  def self.up
    remove_column :posts, :password
    remove_column :comments, :password
  end

  def self.down
    add_column :comments, :password, :string
    add_column :posts, :password, :string
  end
end
