class CreateArchiveCatalogNode < ActiveRecord::Migration
  def self.up
    create_table :archive_catalogue_nodes do |t|
      t.integer :archive_catalogue_id
      t.integer :archive_id
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_catalogue_nodes
  end
end
