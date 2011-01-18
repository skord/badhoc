class Board < ActiveRecord::Base
  belongs_to :category
  has_many :posts, :dependent => :destroy
  has_many :comments, :through => :posts
  validates_uniqueness_of :name, :slug, :description
  validates_presence_of :name, :slug, :description
  validates_presence_of :category_id
  
  attr_accessible :name, :slug, :description, :category_id
end
