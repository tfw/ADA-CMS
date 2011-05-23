class CreateArchiveCatalogIntegrations < ActiveRecord::Migration
  def self.up
    create_table :archive_catalog_integrations do |t|
      t.integer :archive_catalogue_id
      t.integer :archive_id
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_catalog_integrations
  end
end
