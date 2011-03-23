class FixCommentTreeStructure < ActiveRecord::Migration
  def self.up
    say_with_time "Creating comment tree structure" do
      Comment.rebuild!
    end
  end

  def self.down
  end
end

