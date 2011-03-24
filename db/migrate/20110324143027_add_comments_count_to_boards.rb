class AddCommentsCountToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :comments_count, :integer, :default => 0
    Board.all.each do |board|
      board.update_attribute(:comments_count, board.comments.count)
    end
  end

  def self.down
    remove_column :boards, :comments_count
  end
end
