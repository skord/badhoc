class Board < ActiveRecord::Base
  belongs_to :category
  has_many :posts, :dependent => :destroy
  has_many :comments, :through => :posts
  validates_uniqueness_of :name, :slug, :description
  validates_presence_of :name, :slug, :description
  validates_presence_of :category_id
  validates_numericality_of :post_limit, :only_integer => true, :greater_than => 1
  
  attr_accessible :name, :slug, :description, :category_id, :post_limit

  def to_param
    slug
  end

  def children_count
    self.comments_count + self.posts_count
  end
  
  def cleanup!
    self.inactive_posts.not_sticky.where('position > ? and created_at < ?', self.post_limit, 5.minutes.ago).destroy_all
  end

  def cleanup
    self.inactive_posts.not_sticky.where('position > ? and created_at < ?', self.post_limit, 5.minutes.ago)
  end

  
  def active_posts
    self.posts.where('position <= ?', self.post_limit)
  end
  
  def inactive_posts
    self.posts.where('position > ?', self.post_limit)
  end
  
end
