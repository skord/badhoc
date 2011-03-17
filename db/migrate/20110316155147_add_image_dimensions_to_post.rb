class AddImageDimensionsToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :image_width, :integer, :default => 0
    add_column :posts, :image_height, :integer, :default => 0
  end

  def self.down
    remove_column :posts, :image_height
    remove_column :posts, :image_width
  end
end
