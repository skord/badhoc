class Ban < ActiveRecord::Base

  scope :active, where('expires_at > ? OR permanent = ?', Time.now, true)

  attr_accessible :client_ip, :reason, :expires_at, :permanent, :destructive, :nullify
  validates_presence_of :expires_at, :client_ip

  before_save do 
    if self.nullify
      self.nullify_comments
      self.nullify_posts
    elsif self.destructive
      self.destroy_comments
      self.destroy_posts
    else
      self.touch_comments
      self.touch_posts
    end
  end

  def touch_posts
    client_posts = Post.where(:client_ip => self.client_ip)
    unless client_posts.empty?
      client_posts.each do |post|
        post.touch
      end
    end
  end
  
  def touch_comments
    client_comments = Comment.where(:client_ip => self.client_ip)
    unless client_comments.empty?
      client_comments.each do |comment|
        comment.touch
      end
    end
  end

  def nullify_posts
    client_posts = Post.where(:client_ip => self.client_ip)
    unless client_posts.empty?
      client_posts.update_all(:message => '_Content removed due to user ban_')
      client_posts.each do |post|
        post.update_attribute(:postpic, nil)
      end
    end
  end

  def nullify_comments
    client_comments = Comment.where(:client_ip => self.client_ip)
    unless client_comments.empty?
      client_comments.update_all(:message => '_Content removed due to user ban_')
      client_comments.each do |comment|
        comment.update_attribute(:commentpic, nil)
      end
    end
  end
  
  def destroy_posts
    client_posts = Post.where(:client_ip => self.client_ip)
    client_posts.destroy_all unless client_posts.empty?
  end
  
  def destroy_comments
    client_comments = Comment.where(:client_ip => self.client_ip)
    client_comments.destroy_all unless client_comments.empty?
  end
  
  def self.ban_candidates
    ban_candidates = {}
    post_candidates = Post.all.collect {|x| {'Post: ' + x.id.to_s + '-' + x.client_ip => x.client_ip}}
    comment_candidates = Comment.all.collect {|x| {'Comment: ' + x.id.to_s + '-' + x.client_ip => x.client_ip}}
    post_candidates.collect {|x| ban_candidates.merge!(x)}
    comment_candidates.collect {|x| ban_candidates.merge!(x)}
    ban_candidates
  end

end
