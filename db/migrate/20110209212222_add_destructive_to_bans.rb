class AddDestructiveToBans < ActiveRecord::Migration
  def self.up
    add_column :bans, :destructive, :boolean
  end

  def self.down
    remove_column :bans, :destructive
  end
end
