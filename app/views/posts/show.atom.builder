atom_feed do |feed|
 feed.title("badhoc")
 if @post.comments.empty?
   feed.updated(@post.updated_at)
 else
   feed.updated(@post.comments.last.updated_at)
 end
 
 feed.entry(@post) do |entry|
   entry.id
   entry.title(@post.subject)
   entry.content(@post.message, :type => 'html')
   entry.updated
   
   entry.author do |author|
     author.name(@post.name)
   end
 end
 for comment in @post.comments 
   feed.entry(comment) do |entry|
     entry.id
     entry.title(comment.subject)
     entry.content(comment.message, :type => 'html')
     entry.updated
     entry.author do |author|
       author.name(comment.name)
     end
   end
 end
    
end