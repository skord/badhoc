class BansController < ApplicationController
  before_filter :authenticate_admin!
  # GET /bans
  # GET /bans.xml
  def index
    @bans = Ban.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bans }
    end
  end

  # GET /bans/1
  # GET /bans/1.xml
  def show
    @ban = Ban.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ban }
    end
  end

  # GET /bans/new
  # GET /bans/new.xml
  def new
    @ban = Ban.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ban }
    end
  end

  # GET /bans/1/edit
  def edit
    @ban = Ban.find(params[:id])
  end

  # POST /bans
  # POST /bans.xml
  def create
    @ban = Ban.new(params[:ban])

    respond_to do |format|
      if @ban.save
        format.html { redirect_to(@ban, :notice => 'Ban was successfully created.') }
        format.xml  { render :xml => @ban, :status => :created, :location => @ban }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ban.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bans/1
  # PUT /bans/1.xml
  def update
    @ban = Ban.find(params[:id])

    respond_to do |format|
      if @ban.update_attributes(params[:ban])
        format.html { redirect_to(@ban, :notice => 'Ban was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ban.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bans/1
  # DELETE /bans/1.xml
  def destroy
    @ban = Ban.find(params[:id])
    @ban.destroy

    respond_to do |format|
      format.html { redirect_to(bans_url) }
      format.xml  { head :ok }
    end
  end
    
end
