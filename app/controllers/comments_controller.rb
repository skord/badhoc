class CommentsController < ApplicationController

  before_filter :authenticate_admin!, :except => [:index, :show, :new, :create]
  # GET /comments
  # GET /comments.xml
  
  respond_to :html
  
  def index
    @comments = post.comments.all

    respond_with [post, @comments]
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = post.comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
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
        @comment.post.move_to_top
        flash[:notice] = 'Comment created'
        redirect_to(post_path(post))
      else
        render "new"
      end
    }
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = post.comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
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
