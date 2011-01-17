class AddCounterCacheToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :posts_count, :integer, :default => 0
    
    Board.reset_column_information
    Board.find(:all).each do |p|
      Board.update_counters p.id, :posts_count => p.posts.length
    end
  end

  def self.down
    remove_column :boards, :posts_count
  end
end
