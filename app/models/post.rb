class Post < ActiveRecord::Base
  acts_as_list 
  
  cattr_reader :per_page
  @@per_page = 5
  
  
  
  has_attached_file :postpic,
                    :styles => {:small => '128x128#',
                                :thumb => '64x64#'}
                                
  before_validation do
    self.name = tripcode(self.name)
  end

  before_destroy do
    self.destroy_attached_files
  end
  
  scope :has_attachment, where('postpic_file_name is not ?', nil)
  scope :no_attachment, where('postpic_file_name is ?', nil)
  default_scope where('position < ?', 101)
  validates_presence_of :name, :message => "can't be blank"

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
