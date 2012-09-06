class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
