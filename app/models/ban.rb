class Ban < ActiveRecord::Base

scope :active, where('expires_at > ? OR permanent = ?', Time.now, true)

attr_accessible :client_ip, :reason, :expires_at, :permanent

def self.ban_candidates
  ban_candidates = {}
  post_candidates = Post.all.collect {|x| {'Post: ' + x.id.to_s + '-' + x.client_ip => x.client_ip}}
  comment_candidates = Comment.all.collect {|x| {'Comment: ' + x.id.to_s + '-' + x.client_ip => x.client_ip}}
  post_candidates.collect {|x| ban_candidates.merge!(x)}
  comment_candidates.collect {|x| ban_candidates.merge!(x)}
  ban_candidates
end

end
