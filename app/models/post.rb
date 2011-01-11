class Post < ActiveRecord::Base
  acts_as_list 
  
  cattr_reader :per_page
  @@per_page = 10
  
  
  
  has_attached_file :postpic,
                    :styles => {:small => '128x128#',
                                :thumb => '64x64#'}
                                
  before_validation do
    self.name = tripcode(self.name)
  end

  after_save do
    Post.inactive.where("created_at < ?", Time.now - 5.minutes).destroy_all
  end

  before_destroy do
    self.destroy_attached_files
  end
    
  scope :has_attachment, where('postpic_file_name is not ?', nil)
  scope :no_attachment, where('postpic_file_name is ?', nil)
  scope :active, where('position < ?', 101)
  scope :inactive, where('position > ?', 101)
  validates_presence_of :name, :message => "can't be blank"

  validates_attachment_presence :postpic

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
  
  attr_protected :client_ip, :tripcoded, :position
end
