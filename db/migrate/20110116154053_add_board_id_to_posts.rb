class AddBoardIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :board_id, :integer
    add_index :posts, :board_id
    Post.update_all(:board_id => Board.first.id) unless Board.count == 0
  end

  def self.down
    remove_index :posts, :board_id
    remove_column :posts, :board_id
  end
end