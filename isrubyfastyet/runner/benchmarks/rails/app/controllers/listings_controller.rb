class ListingsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @listings = Listing.all
    
    respond_to do |format|
      format.html
      format.xml { render :xml => 
      @listings.to_xml(:include => [:user, :bids], :except => :image, :methods => :image_url) }
      format.json { render :json => @listings }
    end
  end
  
  def show
    @listing = Listing.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => 
      @listing.to_xml(:include => [:user, :bids], :except => :image, :methods => :image_url) }
      format.json { render :json => @listing }
    end
  end
  
  def new
    @listing = Listing.new
  end
  
  def create
    @listing = current_user.listings.build(params[:listing])
    
    if @listing.save
      redirect_to @listing
    else
      render 'new'
    end
  end
  
  def edit
    @listing = current_user.listings.find(params[:id])
  end
  
  def update
    @listing = current_user.listings.find(params[:id])
    if @listing.update_attributes(params[:listing])
      flash[:notice] = 'Listing updated.'
      redirect_to @listing
    else
      flash.now[:alert] = "There were problems saving."
      render 'edit'
    end
  end
  
  def destroy
    @listing = current_user.listings.find(params[:id])
    @listing.destroy
    redirect_to listings_path
  end
end




