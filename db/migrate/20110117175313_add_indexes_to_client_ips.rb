class AddIndexesToClientIps < ActiveRecord::Migration
  def self.up
    add_index :posts, :client_ip
    add_index :comments, :client_ip
  end

  def self.down
    remove_index :comments, :client_ip
    remove_index :posts, :client_ip
    mind
  end
end