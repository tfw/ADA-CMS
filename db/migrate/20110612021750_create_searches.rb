class CreateSearches < ActiveRecord::Migration
    extend Inkling::Util::MigrationHelpers
        
  def self.up
    create_table :searches do |t|
      t.integer :user_id
      t.integer :archive_id
      t.string :filters
      t.string :terms
      t.string :title
      t.timestamps
    end
    
    add_foreign_key(:searches, :user_id, :users)
  end

  def self.down
    drop_table :searches
  end
end
