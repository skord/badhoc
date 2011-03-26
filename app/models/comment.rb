class Comment < ActiveRecord::Base
  include TripcodeHelper 

  acts_as_nested_set :scope => :post
  
  POST_COMMENT_LIMIT = 100

  belongs_to :post, :counter_cache => true, :touch => true
  belongs_to :board, :touch => true
  
  
  # Callbacks. They're here because they have to go before the attachment definition.
  before_validation :set_tripcoded_name
  after_create      :increment_board_comments_counter
  before_save       :pull_image_geometries
  after_create      :increment_board_attachments_size
  before_destroy    :decrement_board_attachments_size
  after_destroy     :decremement_board_comments_counter
  
  has_attached_file :commentpic, 
                    :styles => {:small => '200x200#',
                                :thumb => '64x64#'}
  
  scope :has_attachment, where('commentpic_file_name is not ?', nil)
  scope :no_attachment, where('commentpic_file_name is ?', nil)

  
  # Callback Methods
 
  def set_tripcoded_name
    self.name = tripcode(self.name)
  end

  def pull_image_geometries
    tempfile = self.commentpic.queued_for_write[:original]
    unless tempfile.nil?
      dimensions = Paperclip::Geometry.from_file(tempfile)
      self.image_width = dimensions.width
      self.image_height = dimensions.height
    end    
  end
  
  # Faking a comment count for board since there's no direct association.
    
  def increment_board_comments_counter
    Board.increment_counter(:comments_count, self.post.board.id)
  end
  
  def decremement_board_comments_counter
    Board.decrement_counter(:comments_count, self.post.board.id)
  end
  
  def increment_board_attachments_size
    if self.commentpic.size != nil
      board = self.post.board
      board.increment!(:attachments_size, by = self.commentpic.size)
    end
  end

  def decrement_board_attachments_size
    if self.commentpic.size != nil
      board = self.post.board
      board.decrement!(:attachments_size, by = self.commentpic.size)
    end
  end
    
  # Validations
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
