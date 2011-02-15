module CommentsHelper
  def comments_chart_series(comments, start_time)
    comments_by_day = comments.where(:created_at => start_time.beginning_of_day..Time.zone.now.end_of_day).group("date(comments.created_at)").select("comments.created_at, count(*) as comment_count")
    (start_time.to_date..Date.today).map do |date|
      comment = comments_by_day.detect {|comment| comment.created_at.to_date == date}
      comment && comment.comment_count.to_f || 0
    end.inspect
  end
end
