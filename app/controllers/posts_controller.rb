class PostsController < ApplicationController

  # Yeah, there's a lot of caching methods here, its much of an attempt to cover different cases.
  # Because of CSRF protection and user sessions, the response headers really only do anything
  # at all if you're stripping cookies at the reverse proxy session. If you setup that way,
  # I'd recommend a filter to avoid the /admin path and other admin actions you can find in 
  # rake routes. See, isn't RESTfulness super? TL;DR: Cache headers mean nothing unless you've 
  # configured your reverse proxy to toss cookies. 
  #
  # There is a conditional get for index, which will throw a 304 unless the 
  # content in the block and the last modified date has changed.
  #
  # The action caching on the show method is a lot faster than fragment caching or even the 
  # conditional get. Does not work for the index action because of pagination. Uses more memcached
  # space, but its worth it. It bypasses doing the db query at all, hence faster. If you're limited
  # to a small memcached instance, it might be better to modify this so the action caching is turned 
  # off but keep the conditional get. The conditional get is in place as well as the action caching 
  # for the case where the cache is expired or not available. 
  #
  # In the views there are quite a bit of partial fragments cached. The render times for comments 
  # and post names, emails etc are a bit high and there are quite a few of these.

  respond_to :html, :js

  before_filter :authenticate_admin!, :except => [:index, :show, :new, :create]
  caches_action :show, :layout => false
  # GET /posts
  # GET /posts.xml
  def index
    @board = board
    @post = board.posts.new
    @posts = board.posts.active.paginate :order => 'sticky DESC, position ASC', :page => params[:page], :per_page => 10, :include => :comments
    @all_posts = board.posts.active

    if stale?(:last_modified => @board.updated_at.utc, :etag => @posts)
      respond_with [board, @posts] do |format|
        format.html {
          # Since pagination is done via JS if available, this mostly targets robots. 
          # It's still set pretty low because the #1 landing spot is board_posts_path
          # in html format.
          response.headers['Cache-Control'] = 'public, max-age=15'
        }
        format.atom {
          # For varnish. Anyone that cares this much about an atom feed should find another way.
          response.headers['Cache-Control'] = 'public, max-age=60'
        }
        format.js
      end
    end
    
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id], :include => :comments)
    @comment = @post.comments.new

    if stale?(:last_modified => @post.updated_at.utc, :etag => @post)
      respond_to do |format|
        format.html {
          # Anything longer than this can lead to some "odd" behavior. New posts should roll in via JS
          # but if someone hits refresh they'll get the reverse proxy cache version, but if they wait 
          # a moment they'll get the updates via JS.
          response.headers['Cache-Control'] = 'public, max-age=30'
        }
        format.atom {
          # For varnish. Anyone that cares this much about an atom feed should find another way.
          response.headers['Cache-Control'] = 'public, max-age=60'
        }
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
        expire_action :action => :show
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
