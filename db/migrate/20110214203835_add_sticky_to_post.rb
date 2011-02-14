class AddStickyToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :sticky, :boolean, :default => false
    Post.update_all(:sticky => false)
  end

  def self.down
    remove_column :posts, :sticky
  end
end
