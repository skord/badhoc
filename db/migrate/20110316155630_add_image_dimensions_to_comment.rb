class AddImageDimensionsToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :image_width, :integer, :default => 0
    add_column :comments, :image_height, :integer, :default => 0
  end

  def self.down
    remove_column :comments, :image_height
    remove_column :comments, :image_width
  end
end
