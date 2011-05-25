class CreateArchiveCatalogNode < ActiveRecord::Migration
  def self.up
    create_table :archive_catalog_nodes do |t|
      t.integer :archive_catalog_id
      t.integer :archive_study_id
      t.integer :catalog_position
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_catalog_nodes
  end
end
