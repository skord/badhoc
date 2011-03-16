class Comment < ActiveRecord::Base
  include TripcodeHelper 

  acts_as_nested_set :scope => :post
  
  POST_COMMENT_LIMIT = 100

  belongs_to :post, :counter_cache => true, :touch => true
  belongs_to :board, :touch => true
  
  has_attached_file :commentpic, 
                    :styles => {:small => '200x200#',
                                :thumb => '64x64#'}
  
  scope :has_attachment, where('commentpic_file_name is not ?', nil)
  scope :no_attachment, where('commentpic_file_name is ?', nil)

  
  before_validation do
    self.name = tripcode(self.name)
  end
  
  before_save do
    tempfile = self.commentpic.queued_for_write[:original]
    unless tempfile.nil?
      dimensions = Paperclip::Geometry.from_file(tempfile)
      self.image_width = dimensions.width
      self.image_height = dimensions.height
    end
  end
  
  before_destroy do
    self.destroy_attached_files
  end
  
  validates_presence_of :message
  
  validate  :under_comment_limit
  
  def under_comment_limit
    errors.add("Error Commenting", "This thread is closed.") unless self.post.comments_count <= POST_COMMENT_LIMIT
  end
  
  validate :user_not_banned
  
  def user_not_banned
    errors.add("You Are Banned From Posting for the Following Reason: ","#{Ban.find_by_client_ip(self.client_ip).reason}") unless Ban.active.find_by_client_ip(self.client_ip) == nil
  end
  
  validate :thread_locked
  
  def thread_locked
    errors.add("You cannot post to this for the following reason", "This thread has been locked.") if self.post.locked
  end
    
  def active_ban
    @ban_record ||= Ban.active.find_by_client_ip(self.client_ip)
  end
  
  def active_ban?
    active_ban != nil
  end  
    
  attr_accessible :name, :email, :subject, :message, :password, :commentpic
    


end
