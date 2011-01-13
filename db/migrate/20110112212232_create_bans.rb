class CreateBans < ActiveRecord::Migration
  def self.up
    create_table :bans do |t|
      t.string :client_ip
      t.string :reason

      t.timestamps
    end
    add_index :bans, :client_ip
  end

  def self.down
    remove_index :bans, :client_ip
    drop_table :bans
  end
end