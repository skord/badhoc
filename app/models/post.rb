class Post < ActiveRecord::Base
  include TripcodeHelper

  # It used to be that the post threshold was the entire site. That's fixed as of this commit. 
  # Active post threshold is now per board, hence lowering the number by a factor of 10 here. 
  # Still a small issue though, this needs to be moved to the board model for post aging somehow, 
  # but you end up screwing up the named scopes below. So for now the active threshold for posts
  # is still a global (across every board) value. This is reflected in the weird mix of instance
  # and singleton methods at the bottom until I get that mentally cleared up. 

  ACTIVE_POST_THRESHOLD = 100
  acts_as_list :scope => :board
  
  cattr_reader :per_page
  @@per_page = 10

  has_many :comments, :dependent => :destroy
  belongs_to :board, :counter_cache => true, :touch => true
  
  before_validation :set_tripcoded_name
  before_save       :pull_image_geometries
  

  # There's two choices for an after_create filter to purge old posts.
  # It should be safe to auto-purge expired posts, however this is not an async
  # operation, so it could make posting slower. It could potentially mean chaos
  # if you use non-local storage like S3 and S3 happens to be down. OOPS! 
  # If you want this to go to a worker, try the delayed_job branch, that would be 
  # the smart thing to do anyway. If you'd rather just do it yourself to save some
  # time for users, pick #1. If you never check your site or you're comfortable with
  # the non-async delete, chose #2. #1 is the default.
  #
  # TL;DR. Pick #2 unless this site is your baby or you use S3 or other cloud storage.

  # #1: No auto-cleanup. Periodically run Board.all.each {|board| board.cleanup!} somehow.
  after_create      :increment_board_attachments_size

  # #2: Auto-Cleanup, non-async. You have been warned.
  # after_create      :increment_board_attachments_size, :cleanup!
  
    
  before_destroy    :decrement_board_attachments_size
  
  
  has_attached_file :postpic,
                    :styles => {:small => '200x200#',
                                :thumb => '64x64#'}

  # Bitches don't know bout my named scopes
  scope :has_attachment, where('postpic_file_name is not ?', nil)
  scope :no_attachment, where('postpic_file_name is ?', nil)
  scope :sticky, where('sticky = ?', true)
  scope :not_sticky, where('sticky = ?', false)


  def set_tripcoded_name
    self.name = tripcode(self.name)
  end

  def pull_image_geometries
    tempfile = self.postpic.queued_for_write[:original]
    unless tempfile.nil?
      dimensions = Paperclip::Geometry.from_file(tempfile)
      self.image_width = dimensions.width
      self.image_height = dimensions.height
    end    
  end

  def increment_board_attachments_size
    if self.postpic.size != nil
      board = self.board
      board.increment!(:attachments_size, by = self.postpic.size)
    end
  end

  def decrement_board_attachments_size
    if self.postpic.size != nil
      board = self.board
      board.decrement!(:attachments_size, by = self.postpic.size)
    end
  end
  
  validates_presence_of :name, :message => "can't be blank"

  validates_attachment_presence :postpic, :message => "can't be blank. That means you have to upload something."
  validates_attachment_size :postpic, :less_than => 5.megabytes
  validates_attachment_content_type :postpic, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  validate :user_banned
  
  def user_banned
    errors.add("You Are Banned From Posting for the Following Reason: ","#{Ban.find_by_client_ip(self.client_ip).reason}") unless Ban.active.find_by_client_ip(self.client_ip) == nil
  end

  validates_presence_of :message

  # validate :posting_too_quickly, :on => :create
  # 
  # def posting_too_quickly
  #   errors.add("Error Posting", "You are attempting to post too quickly. Posts are allowed once a minute.") if Post.order('created_at DESC').find_by_client_ip(self.client_ip).created_at > Time.now - 1.minute
  # end
  
  def poster_post_count
    Post.find_all_by_name(self.name).count
  end
  
  def limit_locked?
    self.comments_count >= 100
  end
  
  def lock
    self.update_attribute(:locked, true)
  end
  
  def unlock
    self.update_attribute(:locked, false)
  end
  
  def stickify
    self.update_attribute(:sticky, true)
  end
  
  def unstickify
    self.update_attribute(:sticky, false)
  end
  
  def active_ban
    @ban_record ||= Ban.active.find_by_client_ip(self.client_ip)
  end
  
  def active_ban?
    active_ban != nil
  end
  

  #
  # These are weird, and the english doesn't exactly match the SQL. Basically, you have
  # to read it not as "Created at less than five minutes ago", but rather
  # "The time this was created at is before 5 minutes ago."
  #
  # There are a plethora of cleanup methods rather than doing this the rails way so I can
  # easily explain it to people for the decision they need to make regarding delayed jobs.

  def cleanup
    self.board.cleanup
  end

  def cleanup!
    self.board.cleanup!
  end
  

  attr_accessible :name, :email, :subject, :message, :password, :postpic
end
