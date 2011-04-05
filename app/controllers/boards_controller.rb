class BoardsController < ApplicationController

  before_filter :authenticate_admin!, :except => [:index, :show]
  # GET /boards
  # GET /boards.xml
  def index
    @boards = Board.order('updated_at DESC')

    if stale?(:last_modified => @boards.first.updated_at.utc, :etag => @boards)
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @boards }
      end
    end
  end

  # GET /boards/1
  # GET /boards/1.xml
  def show
    @board = Board.find_by_slug(params[:id])
    @images_size = @board.attachments_size

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/new
  # GET /boards/new.xml
  def new
    @board = Board.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find_by_slug(params[:id])
  end

  # POST /boards
  # POST /boards.xml
  def create
    @board = Board.new(params[:board])

    respond_to do |format|
      if @board.save
        format.html { redirect_to(categories_path, :notice => 'Board was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.xml
  def update
    @board = Board.find_by_slug(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        format.html { redirect_to(categories_path, :notice => 'Board was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.xml
  def destroy
    @board = Board.find_by_slug(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to(boards_url) }
      format.xml  { head :ok }
    end
  end
end
