class AddImagesSizeToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :attachments_size, :integer, :default => 0
  end

  def self.down
    remove_column :boards, :attachments_size
  end
end
