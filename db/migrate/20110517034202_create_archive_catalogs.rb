class CreateArchiveCatalogs < ActiveRecord::Migration
  def self.up
    create_table :archive_catalogs do |t|
      t.string  :title, :null => false 
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_catalogs
  end
end