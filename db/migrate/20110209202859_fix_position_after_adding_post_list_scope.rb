class FixPositionAfterAddingPostListScope < ActiveRecord::Migration
  def self.up
    Board.all.each do |board|
      position = 1
      board.posts.order(:position).each do |post| 
        post.update_attribute(:position, position)
        position += 1
      end
    end
  end

  def self.down
    # yeah, sorry, this is destructive. this here is about the best i can do
    position = 1
    Post.order(:updated_at).each do |post|
      post.update_attribute(:position, position)
      position += 1
    end
  end
end
