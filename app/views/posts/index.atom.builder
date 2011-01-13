atom_feed do |feed|
 feed.title("badhoc")
 feed.updated(@posts.first.created_at)
 
 for post in @posts
   feed.entry(post) do |entry|
     entry.id
     entry.title(post.subject)
     entry.content(post.message, :type => 'html')
     entry.updated
     
     entry.author do |author|
       author.name(post.name)
     end
   end
 end
end