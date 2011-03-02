class CommentsController < ApplicationController

  before_filter :authenticate_admin!, :except => [:index, :show, :new, :create]
  # GET /comments
  # GET /comments.xml
  
  respond_to :html, :js
  
  def index
    @comments = post.comments.where('created_at > ?', Time.at(params[:after].to_i) + 1)

    if stale?(:last_modified => post.comments.last.updated_at, :etag => @comments)
      respond_with [post, @comments] do |format|
        format.html
        format.js
      end
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = post.comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
      format.js
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = post.comments.new

    respond_with [post, @comment]
  end

  # GET /comments/1/edit
  def edit
    @comment = post.comments.find(params[:id])
    
    respond_with [post, @comment]
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = post.comments.new(params[:comment])
    @comment.client_ip = request.remote_ip
    
    respond_with [post, @comment] do |format|
      format.html {
      if @comment.save
        session[:my_name] = params[:comment][:name]
        @comment.post.move_to_top unless @comment.email == 'sage'
        if @comment.email == 'noko'
          redirect_to(post_path(post))
        else
          redirect_to(board_posts_path(post.board))
        end
      else
        flash[:error] = 'Comment could not be added'
        render "new"
      end
    }
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = post.comments.find(params[:id])

    respond_with [post, @comment] do |format|
      format.html {
        if @comment.update_attributes(params[:comment])
          redirect_to(post_path(post))
        else
          render "new"
        end
      }
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    comment = post.comments.find(params[:id])
    
    if comment.destroy
      flash[:notice] = 'The comment was destroyed'
    else
      flash[:alert] = 'The comment could not be destroyed'
    end
    
    respond_with [post, @comment] do |format|
      format.html {redirect_to(post_path(post))}
    end    
  end
  
  private
  
  def post
    @post ||= Post.find(params[:post_id])
  end
  
end
