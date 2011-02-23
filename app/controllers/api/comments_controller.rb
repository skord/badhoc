class Api::CommentsController < ApplicationController
  
  respond_to :xml, :json
  
  def index
    @comments = Comment.select('id, created_at, updated_at, name, tripcoded, email, subject, message, post_id, commentpic_content_type, commentpic_file_name, commentpic_file_size, commentpic_updated_at')
    respond_with @comments do |format|
      format.xml  {render :xml => @comments}
      format.json {render :json => @comments}
    end
  end
  
  def show
    @comment = Comment.select('id, created_at, updated_at, name, tripcoded, email, subject, message, post_id, commentpic_content_type, commentpic_file_name, commentpic_file_size, commentpic_updated_at').find(params[:id])
    respond_with @comment do |format|
      format.xml  { render :xml => @comment }
      format.json { render :json => @comment}
    end
  end
end
