class AddNestedSetFieldsToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :parent_id, :integer
    add_column :comments, :lft, :integer
    add_column :comments, :rgt, :integer
    add_column :comments, :depth, :integer
    add_column :comments, :comments_count, :integer, :default => 0
    say_with_time "Creating comment tree structure" do 
      Comment.rebuild!
    end
    say_with_time "Setting current comment depth" do
      Comment.all.each {|comment| comment.move_to_root}
    end
  end

  def self.down
    remove_column :comments, :comments_count
    remove_column :comments, :depth
    remove_column :comments, :rgt
    remove_column :comments, :lft
    remove_column :comments, :parent_id
  end
end