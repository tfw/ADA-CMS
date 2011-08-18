class RemoveUnusedTables < ActiveRecord::Migration
  def self.up
  	drop_table :inkling_feed_roles
  	drop_table :inkling_permissions
  	drop_table :inkling_can_can_actions
  end

  def self.down
  end
end
