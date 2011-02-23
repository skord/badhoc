class Api::BoardsController < ApplicationController

  respond_to :xml, :json

  def index
    @boards = Board.select('id, name, slug, description, created_at, updated_at')
    respond_with @boards do |format|
      format.xml  {render :xml => @boards}
      format.json {render :json => @boards}
    end
  end
  
  def show
    @board = Board.select('id, name, slug, description, created_at, updated_at').find(params[:id])
    respond_with @board do |format|
      format.xml  {render :xml => @board}
      format.json {render :json => @board}
    end
  end

end
