class AddOrderByToSearches < ActiveRecord::Migration
  def self.up
  	change_table :searches do |t|
  		t.string :order_by
  	end
  end

  def self.down
  	remove_column :searches, :order_by 
  end
end
