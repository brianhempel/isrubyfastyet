class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :listing
  
  validates :amount, :presence => true, :numericality => true
  validate :verify_minimum_bid
  
  def verify_minimum_bid
    if amount && listing.highest_bid && listing.highest_bid.amount >= amount
      errors.add :amount, 'must be higher than the highest bid.'
    end
  end
  
  def to_s
    amount
  end
end
