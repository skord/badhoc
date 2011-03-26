class AddProcessingColumnToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :commentpic_processing, :boolean, :default => false
  end

  def self.down
    remove_column :comments, :commentpic_processing
  end
end
