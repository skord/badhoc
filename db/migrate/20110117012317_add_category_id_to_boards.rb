class AddCategoryIdToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :category_id, :integer
    add_index :boards, :category_id
    Board.update_all(:category_id => Category.find_by_name('Uncategorized').id)
  end

  def self.down
    remove_index :boards, :category_id
    remove_column :boards, :category_id
  end
end