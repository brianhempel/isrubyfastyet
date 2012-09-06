class AddImageToListings < ActiveRecord::Migration
  def self.up
    add_column :listings, :image, :string
  end

  def self.down
    remove_column :listings, :image
  end
end
