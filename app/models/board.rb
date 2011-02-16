class Board < ActiveRecord::Base
  belongs_to :category
  has_many :posts, :dependent => :destroy
  has_many :comments, :through => :posts
  validates_uniqueness_of :name, :slug, :description
  validates_presence_of :name, :slug, :description
  validates_presence_of :category_id
  
  attr_accessible :name, :slug, :description, :category_id
  
  def last_active
    if self.posts.empty?
      return ''
    elsif self.comments.empty?
      return self.posts.last.created_at
    else
      status = self.posts.last.created_at <=> self.comments.last.created_at
      if status == 1
        self.posts.last.created_at
      else
        self.comments.last.created_at
      end
    end
  end
end
