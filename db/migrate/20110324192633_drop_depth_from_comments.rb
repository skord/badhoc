# Calculating depth took on average 80ms, and there's no real reason to keep
# it around for now. 

class DropDepthFromComments < ActiveRecord::Migration
  def self.up
    remove_column :comments, :depth
  end

  def self.down
    add_column :comments, :depth, :integer
  end
end
