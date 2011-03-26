class AddPostLimitToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :post_limit, :integer, :default => 100
  end

  def self.down
    remove_column :boards, :post_limit
  end
end
