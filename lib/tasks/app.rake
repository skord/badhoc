namespace :app do   

  desc 'Cleanup expired posts.'  
  task :cleanup => :environment do
    puts "There are #{Post.cleanup} expired posts. Cleaning"
    Post.cleanup!
    puts 'Clean!'
  end
  
end