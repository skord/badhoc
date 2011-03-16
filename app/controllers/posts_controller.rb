class PostsController < ApplicationController

  respond_to :html, :js

  before_filter :authenticate_admin!, :except => [:index, :show, :new, :create]
  # GET /posts
  # GET /posts.xml
  def index
    @board = board
    @post = board.posts.new
    @posts = board.posts.active.paginate :order => 'sticky DESC, position ASC', :page => params[:page], :per_page => 10, :include => :comments
    @all_posts = board.posts.active

    # For varnish. Anyone that cares this much about an atom feed should find another way.
    if request.format.atom?
      response.headers['Cache-Control'] = 'public, max-age=60'
    end
    
    if stale?(:last_modified => @board.updated_at.utc, :etag => @posts)
      respond_with [board, @posts] do |format|
        format.html # index.html.erb
        format.atom
        format.js
      end
    end
    
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id], :include => :comments)
    @comment = @post.comments.new

    # For varnish. Anyone that cares this much about an atom feed should find another way.
    if request.format.atom?
      response.headers['Cache-Control'] = 'public, max-age=60'
    end
  
    if stale?(:last_modified => @post.updated_at.utc, :etag => @post)
      respond_to do |format|
        format.html # show.html.erb
        format.atom
        format.js
      end
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = board.posts.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /posts/1/edit
  def edit
    @post = board.posts.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = board.posts.new(params[:post])
    @client_ip = request.remote_ip
    @post.client_ip = @client_ip

    respond_to do |format|
      if @post.save
        session[:my_name] = params[:post][:name]
        @post.move_to_top
        format.html { 
          if @post.email == 'noko'
            redirect_to(board_post_path(board, @post)) 
          else
            redirect_to(board_posts_path)
          end
          }
      else
        format.html { render 'new' }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = board.posts.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(board_posts_path, :notice => 'Post was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = board.posts.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(board_posts_path) }
    end
  end
  
  def lock
    @post = Post.find(params[:post_id])
    @post.lock
    @post.touch
    respond_to do |format|
      if @post.save
        format.html { redirect_to(post_path(@post), :notice => 'Post locked.') }
        format.js
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def unlock
    @post = Post.find(params[:post_id])
    @post.unlock
    @post.touch
    respond_to do |format|
      if @post.save
        format.html { redirect_to(post_path(@post), :notice => 'Post unlocked.') }
        format.js
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def stickify
    @post = Post.find(params[:post_id])
    @post.stickify
    @post.touch
    respond_to do |format|
      if @post.save
        format.html { redirect_to(board_posts_path(@post.board), :notice => 'Post stickified.') }
        format.js
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def unstickify
    @post = Post.find(params[:post_id])
    @post.unstickify
    @post.touch
    respond_to do |format|
      if @post.save
        format.html { redirect_to(board_posts_path(@post.board), :notice => 'Post unstickified.') }
        format.js
      else
        format.html { render :action => "edit" }
      end
    end
  end

  
  private
  
  def board
    @board ||= Board.find(params[:board_id])
  end
end
