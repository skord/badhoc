module PostsHelper
  def posts_chart_series(posts, start_time)
    posts_by_day = posts.where(:created_at => start_time.beginning_of_day..Time.zone.now.end_of_day).group("date(posts.created_at)").select("posts.created_at, count(*) as post_count")
    (start_time.to_date..Date.today).map do |date|
      post = posts_by_day.detect {|post| post.created_at.to_date == date}
      post && post.post_count.to_f || 0
    end.inspect
  end
end
