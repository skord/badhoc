class AddExpirationsToBans < ActiveRecord::Migration
  def self.up
    add_column :bans, :expires_at, :datetime
    add_column :bans, :permanent, :boolean
  end

  def self.down
    remove_column :bans, :permanent
    remove_column :bans, :expires_at
  end
end
