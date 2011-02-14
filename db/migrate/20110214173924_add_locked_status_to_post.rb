class AddLockedStatusToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :locked, :boolean, :default => false
    Post.update_all(:locked => false)
  end

  def self.down
    remove_column :posts, :locked
  end
end
