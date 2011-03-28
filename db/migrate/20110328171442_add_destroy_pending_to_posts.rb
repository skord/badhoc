class AddDestroyPendingToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :destroy_pending, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :destroy_pending
  end
end
