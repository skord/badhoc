atom_feed do |feed|
 feed.title("badhoc")
 feed.updated(@posts.first.created_at)
 
 for post in @posts
   feed.entry(post) do |entry|
     entry.title(post.subject)
     entry.content(user_text_markdown("![#{post.postpic.original_filename}](#{post.postpic.url(:small)})\r\n\r\n" + post.message), :type => 'html')
     entry.updated
     
     entry.author do |author|
       if post.tripcoded?
         author.name(post.name + ' (Tripcoded) ')
       else
         author.name(post.name)
       end
     end
   end
 end
end