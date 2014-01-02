class BidMailer < ActionMailer::Base
  default :from => "eHarbor Robot <eharbor@example.com>"

  def bid_notification(bid)
    @bid = bid
    mail(:to => bid.listing.user.email, 
          :subject => "New bid on #{bid.listing.title}")
  end
end
