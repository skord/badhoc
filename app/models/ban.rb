class Ban < ActiveRecord::Base

scope :active, where('expires_at > ? OR permanent = ?', Time.now, true)

attr_accessible :client_ip, :reason, :expires_at, :permanent
validates_presence_of :expires_at

# Touch comments and posts of client_ip to update caches after creating ban
after_save do 
  client_posts= Post.find_all_by_client_ip(self.client_ip)
  client_comments= Post.find_all_by_client_ip(self.client_ip)
  unless client_posts.nil?
    client_posts.each do |post|
      post.touch
    end
  end
  unless client_comments.nil?
    client_comments.each do |comment|
      comment.touch
    end
  end
end

# Touch comments and posts of client_ip to update caches after removing ban
after_destroy do 
  client_posts= Post.find_all_by_client_ip(self.client_ip)
  client_comments= Post.find_all_by_client_ip(self.client_ip)
  unless client_posts.nil?
    client_posts.each do |post|
      post.touch
    end
  end
  unless client_comments.nil?
    client_comments.each do |comment|
      comment.touch
    end
  end
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
