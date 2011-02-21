class PostsController < ApplicationController

  respond_to :html

  before_filter :authenticate_admin!, :except => [:index, :show, :new, :create]
  # GET /posts
  # GET /posts.xml
  def index
    @board = board
    @post = board.posts.new
    @posts = board.posts.active.paginate :order => 'sticky DESC, position ASC', :page => params[:page], :per_page => 10, :include => :comments
    
    respond_with [board, @posts] do |format|
      format.html # index.html.erb
      format.atom
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.new

    respond_to do |format|
      format.html # show.html.erb
      format.atom
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
            redirect_to(board_post_path(board, @post), :notice => 'Post successful.') 
          else
            redirect_to(board_posts_path, :notice => 'Post successful.')
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
