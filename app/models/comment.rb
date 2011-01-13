class Comment < ActiveRecord::Base
  POST_COMMENT_LIMIT = 100

  belongs_to :post, :counter_cache => true
  
  has_attached_file :commentpic, 
                    :styles => {:small => '128x128#',
                                :thumb => '64x64#'}
  
  scope :has_attachment, where('commentpic_file_name is not ?', nil)
  scope :no_attachment, where('commentpic_file_name is ?', nil)

  
  before_validation do
    self.name = tripcode(self.name)
  end
  
  before_destroy do
    self.destroy_attached_files
  end
  
  validate  :under_comment_limit
  
  def under_comment_limit
    errors.add("Error Commenting", "This thread is closed.") unless self.post.comments_count <= POST_COMMENT_LIMIT
  end
  
  validate :user_not_banned
  
  def user_not_banned
    errors.add("You Are Banned From Posting for the Following Reason: ","#{Ban.find_by_client_ip(self.client_ip).reason}") unless Ban.find_by_client_ip(self.client_ip) == nil
  end
    
  attr_protected :tripcoded, :client_ip  
    
  private 
  
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
end
