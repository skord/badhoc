class FixupPostAndCommentsFileSizes < ActiveRecord::Migration
  def self.up
    say_with_time "Updating Post Pic Dimensions" do
      Post.all.each do |post|
        if post.postpic.options[:storage] == :filesystem
          dimensions = Paperclip::Geometry.from_file(post.postpic)
          post.image_width= dimensions.width
          post.image_height= dimensions.height
          post.save
        end
      end
    end
    say_with_time "Updating Comment Pic Dimensions" do
      Comment.has_attachment.each do |comment|
        if comment.commentpic.options[:storage] == :filesystem
          dimensions = Paperclip::Geometry.from_file(comment.commentpic)
          comment.image_width= dimensions.width
          comment.image_height= dimensions.height
          comment.save
        end
      end
    end
  end

  def self.down
    say_with_time 'Reverting Post Image Dimensions 0' do
      Post.update_all(:image_width => 0, :image_height => 0)
      Post.all.each {|post| post.touch}
    end
    say_with_time 'Reverting Comment Image Dimensions to 0' do 
      Comment.has_attachment.update_all(:image_width => 0, :image_height => 0)
      Comment.has_attachment.each {|comment| comment.touch}
    end
  end
end
