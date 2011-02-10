class PostsController < ApplicationController

  respond_to :html

  before_filter :authenticate_admin!, :except => [:index, :show, :new, :create]
  # GET /posts
  # GET /posts.xml
  def index
    @post = board.posts.new
    @posts = board.posts.active.paginate :order => 'position ASC', :page => params[:page], :per_page => 10, :include => :comments
    
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
  
  private
  
  def board
    @board ||= Board.find(params[:board_id])
  end
end
