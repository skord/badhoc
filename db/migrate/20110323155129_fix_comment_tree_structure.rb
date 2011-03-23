class FixCommentTreeStructure < ActiveRecord::Migration
  def self.up
    say_with_time "Creating comment tree structure" do
      Comment.rebuild!
    end
    say_with_time "Setting current comment depth" do
      Comment.all.each {|comment| comment.move_to_root}
    end
  end

  def self.down
  end
end

