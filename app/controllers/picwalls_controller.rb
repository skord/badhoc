class PicwallsController < ApplicationController

  before_filter :authenticate_admin!, :except => [:index, :show, :new, :create]
  # GET /picwalls
  # GET /picwalls.xml
  def index
    @picwalls = Picwall.active.paginate :order => 'updated_at DESC', :page => params[:page], :per_page => 10, :include => :comments

    if stale?(:last_modified => @picwalls.last.updated_at.utc, :etag => @picwalls)
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @picwalls }
      end
    end
  end

  # GET /picwalls/1
  # GET /picwalls/1.xml
  def show
    @picwall = Picwall.find(params[:id], :include => :comments)

    if stale?(:last_modified => @picwall.updated_at.utc, :etag => @picwall)
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @picwall }
      end
    end
  end

  # GET /picwalls/new
  # GET /picwalls/new.xml
  def new
    @picwall = Picwall.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @picwall }
    end
  end

  # GET /picwalls/1/edit
  def edit
    @picwall = Picwall.find(params[:id])
  end

  # POST /picwalls
  # POST /picwalls.xml
  def create
    @picwall = Picwall.new(params[:picwall])

    respond_to do |format|
      if @picwall.save
        format.html { redirect_to(@picwall, :notice => 'Picwall was successfully created.') }
        format.xml  { render :xml => @picwall, :status => :created, :location => @picwall }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @picwall.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /picwalls/1
  # PUT /picwalls/1.xml
  def update
    @picwall = Picwall.find(params[:id])

    respond_to do |format|
      if @picwall.update_attributes(params[:picwall])
        format.html { redirect_to(@picwall, :notice => 'Picwall was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @picwall.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /picwalls/1
  # DELETE /picwalls/1.xml
  def destroy
    @picwall = Picwall.find(params[:id])
    @picwall.destroy

    respond_to do |format|
      format.html { redirect_to(picwalls_url) }
      format.xml  { head :ok }
    end
  end
end
