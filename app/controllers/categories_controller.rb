class CategoriesController < ApplicationController

  before_filter :authenticate_admin!, :except => [:index, :show]

  respond_to :html

  def index
    @categories = Category.all(:include => :boards)
    if stale?(:last_modified => Board.order('updated_at DESC').first.updated_at.utc, :etag => @categories)
      respond_with @categories
    end
  end

  def show
    @category = Category.find(params[:id])
    respond_with @category
  end

  def new
    @category = Category.new
    respond_with @category
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to(categories_path, :notice => 'Category was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to(categories_path, :notice => 'Category was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
    end
  end
end
