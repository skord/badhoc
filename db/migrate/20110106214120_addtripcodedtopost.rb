class Addtripcodedtopost < ActiveRecord::Migration
  def self.up
    add_column :posts, :tripcoded, :boolean
    Post.update_all(:tripcoded => false)
  end

  def self.down
    remove_column :posts, :tripcoded
  end
end