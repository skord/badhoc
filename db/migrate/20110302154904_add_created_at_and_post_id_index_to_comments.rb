class AddCreatedAtAndPostIdIndexToComments < ActiveRecord::Migration
  def self.up
    add_index :comments, [:created_at, :post_id]
  end

  def self.down
    remove_index :comments, [:created_at, :post_id]
  end
end