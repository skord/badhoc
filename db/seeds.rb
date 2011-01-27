# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Category.destroy_all
Board.destroy_all

Board.create!(:name => 'Random', :slug => 'b', :description => 'Random', :category_id => Category.find_or_create_by_name('Uncategorized').id)

Post.create!(:name => "skord", 
             :email => "", 
             :subject => "Welcome!", 
             :message => "You've just installed Badhoc, I hope it wasn't entirely too difficult, driving you to seek blood revenge.\r\n\r\nIf you need help with anything, need to pitch a gripe, have a feature request, or want to help, see the [Github Page](https://github.com/skord/badhoc). The best way to get something done besides fork it, patch it, and get a pull request is to open an issue there. \r\n\r\nThere's a few more posts that have automatically been put below explaining some of the features of the app, feel free to delete them when you're done with them. \r\n\r\nIf you haven't figured it out yet, the admin sign in is [here](/admins/sign_in). After you sign in, there should be some admin options displayed in-line with everything else.", 
             :client_ip => "127.0.0.1",
             :postpic => File.open("#{Rails.root}/db/seed_data/bigdish.jpg")
            )

Post.create!(:name => "skord", 
             :email => "", 
             :subject => "Markdown Support (AKA Abuse Potential)", 
             :message => "Posts and comments support the Markdown syntax, which you can learn more about at [Daring Fireball](http://daringfireball.net/projects/markdown/syntax).\r\n\r\nWhy Markdown\r\n----------------\r\n\r\nOk, that's a blatant abuse. I'd found that I needed to explain something to someone once and it seemed like a waste to go put it in a gist or pastebin.\r\n\r\n_also_, people often emphasize things in markdown-like syntax anyway, so it just sort of fit. sort of like \\_this\\_ turns into _this_.\r\n\r\nI'm sure this will be abused like crazy and I'll probably have to pull it from the sheer obnoxiousness of posts in all h1.", 
             :client_ip => "127.0.0.1",
             :postpic => File.open("#{Rails.root}/db/seed_data/markdownsyntax.png")
             )
             
Post.create!(:name => "skord", 
             :email => "", 
             :subject => "Post Index", 
             :message => "The first thing you might note is that the __New Post__ and __New Comment__ boxes are hidden by default, you'll have to click the boxes to unhide the form. \r\n\r\nTo the left of the average post is the pic attached to it, and box under it of the latest 9 images attached to its comments. There could be, and probably are more comments and pictures attached, but this is just the latest 9. Same goes with the comments field to the right. \r\n\r\nYou can click show to get the entire threadlist or click __picwall__ to get a page with all of the pics in the post in one spot. ", 
             :client_ip => "127.0.0.1",
             :postpic => File.open("#{Rails.root}/db/seed_data/Post-overview.png")
            )

Post.create!(:name => "skord", 
             :email => "", 
             :subject => "And The Tripcodes...", 
             :message => "So doing the whole ShiftJIS thing is completely out of the question for a number of reasons. Here's the tripcode method as it appears in the post and comments models. \r\n\r\n    def tripcode(string)\r\n      if string =~ /#/\r\n        name, salt = string.split('#')\r\n        salt = salt + 'H..'\r\n        tripcoded_name = name + '!' + (name.crypt(salt))[-10..-1].to_s\r\n        self.tripcoded = true\r\n        return tripcoded_name\r\n      else\r\n        self.tripcoded = false\r\n        string\r\n      end\r\n    end\r\n\r\nI'm more than willing to entertain different ideas on this, but I'm staunch on supporting unicode. ", 
             :client_ip => "127.0.0.1",
             :postpic => File.open("#{Rails.root}/db/seed_data/tripcodecode.png")
            )

# This is to get around the mass assignment protection...
Post.update_all(:board_id => Board.find_by_name('Random').id, :client_ip => '127.0.0.1')
# Then you have to manually update the counter caches since you bypassed it.
Board.reset_column_information
Board.find(:all).each do |p|
  Board.update_counters p.id, :posts_count => p.posts.length
end

comment = Post.find_by_subject("And The Tripcodes...").comments.new
comment.name= 'skord'
comment.subject= 'Offending the colorblind for sure...'
comment.message= "if you put a tripcoded name in the name field, like _user#name_, after submission it will be highlighted in blue. If someone has a bang in what they put in the name field, the name will not be highlighted. This highlighting happens all over the app. " 
comment.client_ip= '127.0.0.1'
comment.commentpic= File.open("#{Rails.root}/db/seed_data/lituptripcode.png")
comment.save!