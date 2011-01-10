class AddClientIpAddressToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :client_ip, :string
  end

  def self.down
    remove_column :posts, :client_ip
  end
end
