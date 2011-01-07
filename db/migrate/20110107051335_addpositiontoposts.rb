class Addpositiontoposts < ActiveRecord::Migration
  def self.up
    add_column :posts, :position, :integer
  end

  def self.down
    remove_column :posts, :position
  end
end