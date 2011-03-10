class CreateInklingFeedsAndRefactorLogs < ActiveRecord::Migration
  def self.up
    create_table "inkling_feeds" do |t|
      t.datetime "created_at", :null => false
      t.integer  "user_id",    :null => false
      t.string   "title",      :null => false
      t.string   "format",     :null => false
      t.string   "source",     :null => false
      t.string   "criteria"
    end

    create_table "inkling_feed_roles" do |t|
      t.datetime "created_at", :null => false
      t.string   "title",      :null => false
      t.integer  "feed_id",    :null => false
      t.integer  "role_id",    :null => false
    end
    
    add_column :inkling_logs, :category, :string, :null => false
    
  end

  def self.down
    drop_table "inkling_feed_roles"
    drop_table "inkling_feeds"
  end
end
