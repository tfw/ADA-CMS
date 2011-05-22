class CreateArchiveCatalogNode < ActiveRecord::Migration
  def self.up
    create_table :archive_catalog_nodes do |t|
      t.integer :archive_catalogue_id
      t.integer :archive_id
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_catalog_nodes
  end
end
