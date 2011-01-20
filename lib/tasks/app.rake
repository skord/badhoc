namespace :app do   

  desc 'Cleanup expired posts.'  
  task :cleanup => :environment do
    puts "There are #{Post.cleanup} expired posts. Cleaning"
    Post.cleanup!
    puts 'Clean!'
  end
  
  desc 'Generate Secure Tripcode Salt'
  task :tripsalt do
    File.open("#{Rails.root}/config/initializers/tripcode_salt.rb",'w') do |file|
      file.puts "# Generated with ActiveSupport::SecureRandom.hex(128)\nBadhoc::Application.config.secure_tripcode_salt = '#{ActiveSupport::SecureRandom.hex(128)}'"
    end
  end
  
end