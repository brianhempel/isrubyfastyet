class AddUserIdToListings < ActiveRecord::Migration
  def self.up
    add_column :listings, :user_id, :integer
  end

  def self.down
    remove_column :listings, :user_id
  end
end
