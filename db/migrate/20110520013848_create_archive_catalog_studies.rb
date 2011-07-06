class CreateArchiveCatalogStudies < ActiveRecord::Migration
    extend Inkling::Util::MigrationHelpers
        
  def self.up
    create_table :archive_catalog_studies do |t|
      t.integer :archive_catalog_id
      t.integer :archive_study_id
      t.integer :catalog_position
      t.timestamps
    end
    
    add_foreign_key(:archive_catalog_studies, :archive_catalog_id, :archive_catalogs)
    add_foreign_key(:archive_catalog_studies, :archive_study_id, :archive_studies)
  end

  def self.down
    drop_table :archive_catalog_studies
  end
end
