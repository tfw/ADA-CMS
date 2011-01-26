class CreateArchiveStudies < ActiveRecord::Migration
      extend Inkling::Util::MigrationHelpers
      
  def self.up
    create_table :archive_studies do |t|
      t.integer :id
      t.integer :study_id, :null => :false
      t.integer :archive_id, :null => :false
      t.integer :archive_study_integration_id, :null => false
      t.timestamps
    end

    add_foreign_key(:archive_studies, :archive_id, :archives)
    add_foreign_key(:archive_studies, :study_id, :studies)
    add_foreign_key(:archive_studies, :archive_study_integration_id, :archive_study_integrations)
  end

  def self.down
    drop_table :archive_studies
  end
end
