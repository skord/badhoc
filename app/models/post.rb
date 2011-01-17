class Post < ActiveRecord::Base

  ACTIVE_POST_THRESHOLD = 1000
  acts_as_list 
  
  cattr_reader :per_page
  @@per_page = 10
  
  
  has_many :comments, :dependent => :destroy
  belongs_to :board, :counter_cache => true
  has_attached_file :postpic,
                    :styles => {:small => '200x200#',
                                :thumb => '64x64#'}
                                
  before_validation do
    self.name = tripcode(self.name)
  end

  # I thought this could clean up inactive posts, but I think it causes an infinite loop 
  # or something somewhere. Rails will crash with an illegal instruction upon a creating a new record. 
  #
  # before_save do
  #   Post.inactive.where("created_at < ?", Time.now - 5.minutes).destroy_all
  # end

  before_destroy do
    self.destroy_attached_files
  end
    
  scope :has_attachment, where('postpic_file_name is not ?', nil)
  scope :no_attachment, where('postpic_file_name is ?', nil)
  scope :active, where('position <= ?', ACTIVE_POST_THRESHOLD)
  scope :inactive, where('position > ?', ACTIVE_POST_THRESHOLD)
  validates_presence_of :name, :message => "can't be blank"

  validates_attachment_presence :postpic, :message => "can't be blank. That means you have to upload something."
  validates_attachment_size :postpic, :less_than => 5.megabytes
  validates_attachment_content_type :postpic, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  validate :user_not_banned
  
  def user_not_banned
    errors.add("You Are Banned From Posting for the Following Reason: ","#{Ban.find_by_client_ip(self.client_ip).reason}") unless Ban.find_by_client_ip(self.client_ip) == nil
  end

  # validate :posting_too_quickly, :on => :create
  # 
  # def posting_too_quickly
  #   errors.add("Error Posting", "You are attempting to post too quickly. Posts are allowed once a minute.") if Post.order('created_at DESC').find_by_client_ip(self.client_ip).created_at > Time.now - 1.minute
  # end
  
  def tripcode(string)
    if string =~ /#/
      name, salt = string.split('#')
      salt = salt + 'H..'
      tripcoded_name = name + '!' + (name.crypt(salt))[-10..-1].to_s
      self.tripcoded = true
      return tripcoded_name
    else
      self.tripcoded = false
      string
    end
  end
  
  def poster_post_count
    Post.find_all_by_name(self.name).count
  end
  
  def locked?
    self.comments_count >= 100
  end
  
  private
  

  #
  # These are weird, and the english doesn't exactly match the SQL. Basically, you have
  # to read it not as "Created at less than five minutes ago", but rather
  # "The time this was created at is before 5 minutes ago."
  #

  def self.cleanup
    Post.inactive.where("created_at < ?", 5.minutes.ago).count
  end

  def self.cleanup!
    Post.inactive.where("created_at < ?", 5.minutes.ago).destroy_all.count
  end

  
  attr_protected :client_ip, :tripcoded, :position
end
