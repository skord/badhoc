module TripcodeHelper

  def tripcode(string)
    secure_tripcode_salt = Badhoc::Application.config.secure_tripcode_salt
    if string =~ /##/
      name, salt = string.split('##')
      salt = salt + secure_tripcode_salt
      digest = OpenSSL::Digest::Digest.new('sha1')
      tripcoded_name = name + '!!' + (OpenSSL::HMAC.hexdigest(digest, salt, name))[-10..-1].to_s
      self.tripcoded = true
      return tripcoded_name
    elsif string =~ /#/
      name, salt = string.split('#')
      salt = salt + 'H..'
      digest = OpenSSL::Digest::Digest.new('sha1')
      tripcoded_name = name + '!' + (OpenSSL::HMAC.hexdigest(digest, salt, name))[-10..-1].to_s
      self.tripcoded = true
      return tripcoded_name
    else
      self.tripcoded = false
      string
    end
  end

end