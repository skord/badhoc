class Category < ActiveRecord::Base
  # This is strictly for categorization of the different boards. 
  has_many :boards, :dependent => :destroy
  validates_presence_of :name
  validates_uniqueness_of :name
  
  attr_accessible :name
end
