atom_feed do |feed|
 feed.title("Badhoc - #{@post.board.name} - #{@post.id}")
 if @post.comments.empty?
   feed.updated(@post.updated_at)
 else
   feed.updated(@post.comments.last.updated_at)
 end
 
 feed.entry(@post) do |entry|
   entry.title(@post.subject)
   entry.content(user_text_markdown("![#{@post.postpic.original_filename}](#{@post.postpic.url(:small)})\r\n\r\n" + @post.message), :type => 'html')
   entry.updated
   
   entry.author do |author|
     if @post.tripcoded?
       author.name(@post.name + ' (Tripcoded) ')
     else
       author.name(@post.name)
     end
   end
 end
 
 for comment in @post.comments 
   feed.entry(comment, :url => post_comment_url(:id => comment, :post_id => @post)) do |entry|
     entry.title(comment.subject)
     if comment.commentpic?
       entry.content(user_text_markdown("![#{comment.commentpic.original_filename}](#{comment.commentpic.url(:small)})\r\n\r\n" + comment.message), :type => 'html')
     else
       entry.content(user_text_markdown(comment.message), :type => 'html')
     end
     entry.updated
     entry.author do |author|
       if comment.tripcoded?
         author.name(comment.name + ' (Tripcoded) ')
       else
         author.name(comment.name)
       end
     end
   end
 end
    
end