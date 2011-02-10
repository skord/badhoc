class AddNullifyToBan < ActiveRecord::Migration
  def self.up
    add_column :bans, :nullify, :boolean
  end

  def self.down
    remove_column :bans, :nullify
  end
end
