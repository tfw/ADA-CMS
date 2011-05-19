class CreateArchiveCatalogueIntegrations < ActiveRecord::Migration
  def self.up
    create_table :archive_catalogue_integrations do |t|
      t.integer :archive_catalogue_id
      t.string :url
      t.timestamps
    end
  end

  def self.down
  end
end
