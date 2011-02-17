class CreateArchiveStudies < ActiveRecord::Migration
      extend Inkling::Util::MigrationHelpers
      
  def self.up
    create_table :archive_studies do |t|
      t.integer :id
      t.integer :study_id, :null => :false
      t.integer :archive_id, :null => :false
      t.timestamps
    end

    add_foreign_key(:archive_studies, :archive_id, :archives)
    add_foreign_key(:archive_studies, :study_id, :studies)
  end

  def self.down
    drop_table :archive_studies
  end
end
