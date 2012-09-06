class BidsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    @listing = Listing.find(params[:listing_id])
    @bid = @listing.bids.build(params[:bid])
    @bid.user = current_user
    if @bid.save
      BidMailer.bid_notification(@bid).deliver
      respond_to do |format|
        format.html { redirect_to @listing }
      end
    else
      respond_to do |format|
        format.html { render 'listings/show' }
      end
    end
  end
  
end
