class CreateMediaTables < ActiveRecord::Migration
  extend Inkling::Util::MigrationHelpers

  def self.up
    create_table 'media' do |t|
      t.integer :user_id, :null => :false
      t.string :title, :null => false
      t.string :asset_file_name
      t.string :asset_content_type
      t.integer :asset_file_size
      t.datetime :asset_updated_at
      t.timestamps
    end
    add_foreign_key(:media, :user_id, :inkling_users)
    add_index(:media, :user_id)
    add_index(:media, :title, :unique => true)
  end

  def self.down
    drop_table 'media'
  end
end
