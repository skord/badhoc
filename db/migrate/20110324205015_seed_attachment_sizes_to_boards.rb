class SeedAttachmentSizesToBoards < ActiveRecord::Migration
  def self.up
    say_with_time "Caching Byte Sums to Boards.." do 
      Board.all.each do |board|
        posts_sum = board.posts.has_attachment.collect {|x| x.postpic.size}.sum 
        comments_sum = board.comments.has_attachment.collect {|x| x.commentpic.size}.sum
        byte_sum = comments_sum + posts_sum
        board.update_attribute(:attachments_size, byte_sum)
      end
    end
  end

  def self.down
    say_with_time "Setting byte sums to 0..." do 
      Board.update_all(:attachments_size => 0)
    end
  end
end
