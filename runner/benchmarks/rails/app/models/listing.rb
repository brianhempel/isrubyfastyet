class Listing < ActiveRecord::Base
  validates :title, :presence => true
  # validates :title, :format => {:with => /^[A-Z]/, 
  #             :message => 'must begin with a capital letter'}
  # validates :description, :presence => true
  
  belongs_to :user
  has_many :bids
  
  mount_uploader :image, ImageUploader
  
  def highest_bid
    bids.order('amount DESC').first
  end
  
  def to_param
    "#{id}-#{title.parameterize}"
  end
end
