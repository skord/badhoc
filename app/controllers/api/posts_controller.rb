class Api::PostsController < ApplicationController

  respond_to :xml, :json

  def index
    @posts = Post.select('id, created_at, updated_at, name, tripcoded, email, subject, message, board_id, postpic_content_type, postpic_file_name, postpic_file_size, postpic_updated_at')
    respond_with @posts do |format|
      format.xml  {render :xml => @posts}
      format.json {render :json => @posts}
    end
  end
  
  def show
    @post = Post.select('id, created_at, updated_at, name, tripcoded, email, subject, message, board_id, postpic_content_type, postpic_file_name, postpic_file_size, postpic_updated_at').find(params[:id])
    respond_with @post do |format|
      format.xml  {render :xml => @post}
      format.json {render :json => @post}
    end
  end
  
  def create
    @post = Post.new(params[:post])
    
    respond_to do |format|
      if @post.save
        format.xml { render :xml => @post, :status => :created, :location => @post }
      else
        format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
