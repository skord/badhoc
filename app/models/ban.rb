class Ban < ActiveRecord::Base

scope :active, where('expires_at > ? OR permanent = ?', Time.now, true)

attr_accessible :client_ip, :reason, :expires_at, :permanent

end
